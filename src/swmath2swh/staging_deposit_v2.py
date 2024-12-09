from swmath2swh.restApi_software_Json import process_metadata
from swmath2swh.convertSoftware_from_json_toXml import convert_json_to_xml
import lxml.etree as ET
import pandas as pd
import subprocess
import time
import tempfile
import os

env = os.environ.copy()
env['SWMATH_USER_DEPOSIT'] = os.getenv('SWMATH_USER_DEPOSIT')
env['SWMATH_PWD_DEPOSIT'] = os.getenv('SWMATH_PWD_DEPOSIT')
env['SWMATH_PWD_DEPOSIT'] = os.getenv('SWMATH_PWD_DEPOSIT')

import requests

r = requests.get("https://oai.staging.mardi4nfdi.org/oai/OAIHandler?verb=GetRecord&metadataPrefix=codemeta&identifier=oai:swmath.org:4532")

xml = r.text


# Write transformed XML to a temporary file
with tempfile.NamedTemporaryFile(mode='w', delete=False, suffix='.xml') as temp_file:
    temp_file.write(xml)
    temp_filename = temp_file.name
    print(f"Temporary file created: {temp_filename}")
# Format current time for deposit status
current_time = time.localtime()
formatted_time = time.strftime("%Y-%m-%d %H:%M:%S", current_time)
dict_deposit = str({
    "deposit_id": str(4532),
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

