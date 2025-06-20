import requests
import csv
import os
import subprocess
import time

class Swhid:
    def __init__(self, url, token):
        self.url = url
        self.token = token
        self.status = None
        self.wait = 0

    def get_wait(self):
        return self.wait

    def get_status(self):
        return self.status

    def save_code_now(self):
        destination = f"https://webapp.staging.swh.network/api/1/origin/save/git/url/{self.url}/"
        body = self.get_body(destination, 'POST')
        return body is not None

    def get_body(self, destination, method='GET'):
        headers = {}
        if self.token:
            headers['Authorization'] = f'Bearer {self.token}'

        try:
            if method == 'GET':
                response = requests.get(destination, headers=headers)
            elif method == 'POST':
                response = requests.post(destination, headers=headers)
            else:
                return None

            self.status = response.status_code
            if response.ok:
                return response.text

            if self.status == 429:  # Rate limit exceeded
                json_content = response.json()
                wait_match = json_content.get('reason')
                if wait_match and any(char.isdigit() for char in wait_match):
                    try:
                        self.wait = int(''.join(filter(str.isdigit, wait_match)))  # Extract numeric part
                    except ValueError:
                        print(f"Could not parse wait time from: {wait_match}")
                    return None

        except Exception as e:
            # Handle exceptions
            print(f"Exception occurred: {e}")

        # Log the response status and content if the request failed
        if response is not None:
            print(f"Failed request. Status code: {response.status_code}, Response text: {response.text}")

        # Default wait for 1 hour if rate limit is hit
        self.wait = 3600
        return None


def url_already_archived(url, archived_file_path):
    if not os.path.exists(archived_file_path):
        return False

    with open(archived_file_path, 'r', newline='') as archived_csv:
        archived_reader = csv.reader(archived_csv)
        for row in archived_reader:
            if row and row[0] == url:
                return True
    return False


def append_archived_url(url, archived_file_path):
    with open(archived_file_path, 'a', newline='') as archived_csv:
        writer = csv.writer(archived_csv)
        writer.writerow([url])


# Example usage
if __name__ == "__main__":

    # Load environment variables from .bashrc
    result = subprocess.run(['bash', '-c', 'source ~/.bashrc && export -p'], stdout=subprocess.PIPE, text=True,
                            check=True)
    for line in result.stdout.splitlines():
        if line.startswith('declare -x '):
            key_value = line[len('declare -x '):].split('=', 1)
            if len(key_value) == 2:
                key, value = key_value
                os.environ[key] = value.strip('"')
    token = os.getenv('SWH_API_TOKEN')

    # The token is read from the environment variable SWH_API_TOKEN
    if token is None:
        print("Error: SWH_API_TOKEN environment variable is not set.")
        exit(1)

    # Current script's directory
    current_dir = os.path.dirname(os.path.abspath(__file__))

    # Navigate up two levels from the 'src/zbmath_rest2oai' directory to the project root
    root_dir = os.path.abspath(os.path.join(current_dir, "../../"))

    # Construct the desired file paths
    file_path = os.path.abspath(os.path.join(root_dir,'./src/local_export/software_data.csv'))
    archived_file_path = os.path.abspath(os.path.join(root_dir, "./src/swmath2swh/archived_software.csv"))

    # Check if file exists
    if not os.path.exists(file_path):
        print(f"Error: File not found at {file_path}")
        exit(1)

    with open(file_path, newline='') as csvfile:
        reader = list(csv.reader(csvfile))
        total_software = len(reader) - 1  # Skip header row count
    current_index = 0
    for row in reader[1:]:

        current_index += 1
        swmathid, url = row

        # Check if URL is already archived
        if url_already_archived(url, archived_file_path):
            print(f"Skipping {url}, already archived.")
            continue

        print(f"Archiving software {current_index} of {total_software}")
        retries = 3
        backoff_time = 5  # Initial backoff time in seconds
        while retries > 0:
            swhid_instance = Swhid(url=url, token=token)
            if swhid_instance.save_code_now():
                print(f"Code for {url} successfully archived.")
                append_archived_url(url, archived_file_path)
                break
            else:
                print(f"Failed to archive code for {url}. Retries left: {retries - 1}")
                if swhid_instance.get_status() is not None:
                    print(f"Reason: Status code {swhid_instance.get_status()} - Waiting for {backoff_time} seconds before retrying.")
                retries -= 1
                time.sleep(backoff_time)
                backoff_time *= 2  # Exponential backoff

        if retries == 0:
            print(f"Failed to archive code for {url} after multiple attempts.")
