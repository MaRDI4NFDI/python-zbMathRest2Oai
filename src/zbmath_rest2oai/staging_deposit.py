import pandas as pd

from zbmath_rest2oai.restApi_software_Json import process_metadata
from zbmath_rest2oai.convertSoftware_from_json_toXml import convert_json_to_xml
import lxml.etree as ET
import requests
import pandas as pd
import subprocess
import time
import tempfile
import os
env = os.environ.copy()
env['SWMATH_USER_DEPOSIT'] = os.getenv('SWMATH_USER_DEPOSIT')
env['SWMATH_PWD_DEPOSIT'] = os.getenv('SWMATH_PWD_DEPOSIT')
env['SWMATH_PWD_DEPOSIT'] = os.getenv('SWMATH_PWD_DEPOSIT')

#csv_file_path = '../test/data/software/swh_swmath.csv'  # Path to your CSV file
csv_file_path = '../test/data/software/swh_swmath_swhid_dir.csv'  # Path to your CSV file
api_url = 'https://api.zbmath.org/v1/software/'  # API URL, can be generalized for any software ID
json_output_path = '../test/data/software/software_with_swhid.json'
xml_output_path = '../test/data/software/software_with_swhid.xml'  # Update with your desired output path
output_log_filename = '../test/data/software/logfile.txt'
xsl_filename = '../xslt/software/xslt-software-Codemeta.xslt'

for (i,swmath_id) in enumerate(pd.read_csv(csv_file_path)['swmathid']):
    if i == 10:
        print("End of the deposit process")
        break
    full_api_url = api_url+str(swmath_id)
    print(full_api_url)
    process_metadata(output_log_filename, csv_file_path, full_api_url, json_output_path)
    convert_json_to_xml(json_output_path, xml_output_path)
    dom = ET.parse(xml_output_path)
    xslt = ET.parse(xsl_filename)
    transform = ET.XSLT(xslt)
    newdom = transform(dom)

    # Write transformed XML to a temporary file
    with tempfile.NamedTemporaryFile(mode='w', delete=False, suffix='.xml') as temp_file:
        temp_file.write(str(newdom))
        temp_filename = temp_file.name
    # Format current time for deposit status
    current_time = time.localtime()
    formatted_time = time.strftime("%Y-%m-%d %H:%M:%S", current_time)
    dict_deposit = str({
        "deposit_id": str(i),
        "deposit_status": "done",
        "deposit_date": formatted_time
    })

    # Run the command with the temporary XML file
    subprocess.run([
        "swh", "deposit", "metadata-only",
        "--username", env["SWMATH_USER_DEPOSIT"],
        "--password", env["SWMATH_PWD_DEPOSIT"],
        "--url", "https://deposit.staging.swh.network/1",
        "--metadata", temp_filename,
        "--format", "json"
    ])