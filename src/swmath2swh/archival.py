import requests
import csv
import os
import time
import sys
from typing import List, Optional, Dict, Tuple
from urllib.parse import quote


class SwhArchiver:
    def __init__(self, token: str):
        self.base_url = "https://archive.softwareheritage.org/api/1/"
        self.token = token
        self.wait_time = 5  # Initial wait time in seconds
        self.max_retries = 3

    def is_already_archived(self, url: str) -> Optional[bool]:
        """Check if URL is already archived in Software Heritage"""
        endpoint = f"{self.base_url}origin/{quote(url, safe='')}/get/"
        retries = self.max_retries

        while retries > 0:
            try:
                response = requests.get(
                    endpoint,
                    headers={"Authorization": f"Bearer {self.token}"} if self.token else {},
                    timeout=30
                )

                if response.status_code == 429:  # Rate limited
                    self._handle_rate_limit(response)
                    retries -= 1
                    continue

                if response.status_code == 404:
                    return False

                response.raise_for_status()

                data = response.json()
                if isinstance(data, dict):
                    return 'origin_visits_url' in data and 'url' in data
                elif isinstance(data, list):
                    return len(data) > 0
                return False

            except requests.exceptions.RequestException as e:
                print(f"Error checking archive status for {url}: {str(e)}")
                if retries == 0:
                    return self._check_via_search(url)
                retries -= 1
                time.sleep(self.wait_time)

        return None

    def _check_via_search(self, url: str) -> Optional[bool]:
        """Fallback method using search endpoint"""
        endpoint = f"{self.base_url}origin/search/git/url/{quote(url)}/"
        try:
            response = requests.get(
                endpoint,
                headers={"Authorization": f"Bearer {self.token}"} if self.token else {},
                timeout=30
            )
            response.raise_for_status()
            data = response.json()
            return len(data.get('origins', [])) > 0
        except Exception as e:
            print(f"Error in fallback search for {url}: {str(e)}")
            return None

    def archive_url(self, url: str) -> bool:
        """Archive a single URL"""
        endpoint = f"{self.base_url}origin/save/git/url/{quote(url, safe='')}/"
        retries = self.max_retries

        while retries > 0:
            try:
                response = requests.post(
                    endpoint,
                    headers={"Authorization": f"Bearer {self.token}"} if self.token else {},
                    timeout=30
                )

                if response.status_code == 429:  # Rate limited
                    self._handle_rate_limit(response)
                    retries -= 1
                    continue

                if response.status_code in (200, 201):
                    return True

                response.raise_for_status()
                return True

            except requests.exceptions.RequestException as e:
                print(f"Error archiving {url}: {str(e)}")
                if hasattr(e, 'response') and e.response is not None:
                    print(f"Response content: {e.response.text}")
                retries -= 1
                time.sleep(self.wait_time)

        return False

    def _handle_rate_limit(self, response):
        """Handle rate limiting with exponential backoff"""
        try:
            data = response.json()
            if 'reason' in data and 'seconds' in data['reason']:
                self.wait_time = int(''.join(filter(str.isdigit, data['reason'])))
            else:
                self.wait_time = min(self.wait_time * 2, 3600)  # Max 1 hour
        except:
            self.wait_time = min(self.wait_time * 2, 3600)

        print(f"Rate limited. Waiting {self.wait_time} seconds...")
        time.sleep(self.wait_time)


def get_unarchived_entries(input_csv: str, archived_csv: str) -> List[Tuple[str, str]]:
    """Get entries that haven't been archived yet (according to our records)"""
    archived_urls = set()

    # Read already archived URLs
    if os.path.exists(archived_csv):
        with open(archived_csv, 'r') as f:
            reader = csv.reader(f)
            next(reader, None)  # Skip header if exists
            archived_urls = {row[1] for row in reader if len(row) > 1}

    unarchived = []
    with open(input_csv, 'r') as f:
        reader = csv.reader(f)
        next(reader)  # Skip header
        for row in reader:
            if len(row) > 1 and row[1] not in archived_urls:
                unarchived.append((row[0], row[1]))  # Keep (id, url) pairs

    return unarchived


def save_archived_entry(entry: Tuple[str, str], archived_csv: str):
    """Save successfully archived entry to file (id, url)"""
    file_exists = os.path.exists(archived_csv)

    with open(archived_csv, 'a', newline='') as f:
        writer = csv.writer(f)
        # Write header if file is new
        if not file_exists:
            writer.writerow(['id', 'source_code'])
        writer.writerow(entry)


def load_token() -> str:
    """Load token from environment variable"""
    token = os.getenv('SWH_API_TOKEN')
    if not token:
        print("Error: SWH_API_TOKEN environment variable is not set.")
        print("Please set it with: export SWH_API_TOKEN=your_token_here")
        sys.exit(1)
    return token


def main():
    # File paths
    current_dir = os.path.dirname(os.path.abspath(__file__))
    root_dir = os.path.abspath(os.path.join(current_dir, "../../"))
    input_csv = os.path.join(root_dir, "src/swmath2swh/software_data.csv")
    archived_csv = os.path.join(root_dir, "src/swmath2swh/archived_software.csv")

    # Load API token
    token = load_token()

    # Get unarchived entries (id, url pairs)
    unarchived_entries = get_unarchived_entries(input_csv, archived_csv)
    total = len(unarchived_entries)
    print(f"Found {total} entries to check/archive")

    # Initialize archiver
    archiver = SwhArchiver(token=token)

    # Process entries
    for i, (entry_id, url) in enumerate(unarchived_entries, 1):
        print(f"\nProcessing {i}/{total}: {url}")

        # First check if already archived
        archived_status = archiver.is_already_archived(url)

        if archived_status is None:
            print("Could not determine archive status, will try to archive")
        elif archived_status:
            print("Already archived in Software Heritage")
            save_archived_entry((entry_id, url), archived_csv)
            time.sleep(0.5)  # Smaller delay for checks
            continue

        # If not archived (or status check failed), try to archive
        print("Attempting to archive...")
        if archiver.archive_url(url):
            save_archived_entry((entry_id, url), archived_csv)
            print("Successfully archived")
        else:
            print("Failed to archive")

        # Small delay between requests to avoid rate limiting
        time.sleep(1)


if __name__ == "__main__":
    main()