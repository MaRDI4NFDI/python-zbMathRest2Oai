import requests
import json
import csv
import os
import subprocess


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

        # Default wait for 1 hour if rate limit is hit
        self.wait = 3600
        return None


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

    # Construct the desired file path
    file_path = os.path.abspath(os.path.join(root_dir, "test/data/software/swh_swmath.csv"))

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
        print(f"Archiving software {current_index} of {total_software}")
        swmathid, url, swhid = row
        swhid_instance = Swhid(url=url, token=token)
        if swhid_instance.save_code_now():
            print(f"Code for {url} successfully archived.")
        else:
            print(f"Failed to archive code for {url}.")
