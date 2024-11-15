import json

import requests

from zbmath_rest2oai.swhid import parse_csv_to_dict
from zbmath_rest2oai.getAsXml import add_references_to_software

# Main function to handle the API request, CSV parsing, and JSON modification
def process_metadata(output_log_filename, csv_file_path, api_url, output_path=None):
    # Extract the swmathid from the API URL
    swmathid = int(api_url.split('/')[-1])  # This extracts the number after 'software/'

    #  Make a GET request to the API
    response = requests.get(api_url)

    #  Check if the request was successful (status code 200)
    if response.status_code == 200:
        # Parse the response JSON content
        data = response.json()
        data["result"]=add_references_to_software(api_url,data["result"])

        #  Parse the CSV and get the dictionary of swmathid to swhid
        swmathid_to_swhid = parse_csv_to_dict(csv_file_path)

        #  Prepare the output log
        output_log = []

        #  Check if the swmathid from the API exists in the CSV mapping
        if swmathid in swmathid_to_swhid:
            matched_swhid = swmathid_to_swhid[swmathid]

            # Modify the JSON structure with the matched swhid
            swhdeposit_data = {
                "swhdeposit:deposit": {
                    "swhdeposit:reference": {
                        "swhdeposit:object": {
                            "@swhid": matched_swhid
                        }
                    },
                    "swhdeposit:metadata-provenance": {
                        "schema:url": "https://api.zbmath.org/v1/"  # Split or modify the URL as needed
                    }
                }
            }

            # Merge this into the original JSON
            data.update(swhdeposit_data)

            # Add a log entry for success
            output_log.append(f"swmathid {swmathid} matched to swhid: {matched_swhid}")
        else:
            # If no match is found
            output_log.append(f"swmathid {swmathid} not found in the CSV file.")

        #  Save the modified JSON data to a file
        output_json_filename = 'output_with_swhid.json'
        with open(output_path, 'w') as json_file:
            json.dump(data, json_file, indent=4, ensure_ascii=False)
        print(f"Data successfully saved to {output_json_filename}")

        #  Save the output log to a file
        # output_log_filename = 'process_log.txt'
        with open(output_log_filename, 'w') as log_file:
            for log_entry in output_log:
                log_file.write(log_entry + '\n')
        print(f"Log successfully saved to {output_log_filename}")
    else:
        print(f"Failed to retrieve data. Status code: {response.status_code}")


csv_file_path = '../../test/data/software/swh_swmath_swhid_dir.csv'  # Path to your CSV file
api_url = 'https://api.zbmath.org/v1/software/8779'  # API URL, can be generalized for any software ID
output_path = '../../test/data/software/software_with_swhid3.json'
output_log_filename = '../../test/data/software/logfile.txt'
process_metadata(output_log_filename, csv_file_path, api_url, output_path)
