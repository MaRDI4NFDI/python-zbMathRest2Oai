from zbmath_rest2oai.restApi_software_Json import process_metadata
from zbmath_rest2oai.convertSoftware_from_json_toXml import convert_json_to_xml
import lxml
import requests


#csv_file_path = '../test/data/software/swh_swmath.csv'  # Path to your CSV file
csv_file_path = '../test/data/software/swh_swmath_swhid_dir.csv'  # Path to your CSV file
api_url = 'https://api.zbmath.org/v1/software/825'  # API URL, can be generalized for any software ID
json_output_path = '../test/data/software/software_with_swhid.json'
xml_output_path = '../test/data/software/software_with_swhid.xml'  # Update with your desired output path
output_log_filename = '../test/data/software/logfile.txt'


process_metadata(output_log_filename, csv_file_path, api_url, json_output_path)

convert_json_to_xml(json_output_path, xml_output_path)