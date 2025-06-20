import requests
import csv
import time


def write_local(api_source):
    """Retrieve data from API and save it to a CSV file."""
    try:
        response = requests.get(api_source, timeout=30)

        if response.status_code != 200:
            print(f"Error: Status {response.status_code} from API")
            print(f"Response: {response.text[:200]}...")  # Show first 200 chars
            return (False, 0)

        if not response.text.strip():
            print("Warning: Empty response")
            return (False, 0)

        try:
            json_res = response.json()
        except ValueError as e:
            print(f"JSON decode error: {e}")
            print(f"Response: {response.text[:200]}...")
            return (False, 0)

        with open('./src/local_export/software_data.csv', mode='a', newline='', encoding='utf-8') as f:
            writer = csv.writer(f)

            # Write headers if file is empty
            if f.tell() == 0:
                writer.writerow(['id', 'source_code'])

            # Process results
            written_count = 0
            results = json_res.get('result', [])
            for software in results:
                if software.get('source_code') is not None:
                    writer.writerow([software['id'], software['source_code']])
                    written_count += 1

            print(f"Processed {written_count}/{len(results)} records")
            return (True, len(results))

    except requests.exceptions.RequestException as e:
        print(f"Request failed: {e}")
        return (False, 0)


def get_last_id():
    """Get the last processed ID from the file."""
    try:
        with open('last_id.txt', 'r') as f:
            content = f.read().strip()
            if content:
                return max(map(int, content.split(';')))
    except (FileNotFoundError, ValueError):
        pass
    return 0


def update_last_id(last_id):
    """Update the last processed ID in the file."""
    with open('last_id.txt', 'a') as f:
        f.write(f"{last_id};")


def main():
    last_id = get_last_id()
    request_delay = 1  # seconds between requests
    batch_size = 500  # results per request

    try:
        while True:  # Infinite loop until break condition
            uri_request = (
                f'https://api.zbmath.org/v1/software/_all?'
                f'start_after={last_id}&results_per_request={batch_size}'
            )

            success, num_results = write_local(uri_request)

            if not success:
                print("Waiting 5 seconds before retry...")
                time.sleep(5)
                continue

            # Update position for next request
            last_id += batch_size
            update_last_id(last_id)

            # Stop if we got fewer results than requested
            if num_results < batch_size:
                print("Reached end of dataset (fewer results than requested)")
                break

            time.sleep(request_delay)

    except KeyboardInterrupt:
        print(f"\nStopped by user. Last ID: {last_id}")
    except Exception as e:
        print(f"Unexpected error: {e}")
    finally:
        print("Script stopped. Safe to rerun to resume.")


if __name__ == "__main__":
    main()