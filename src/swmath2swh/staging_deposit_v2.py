from swmath2swh.restApi_software_Json import process_metadata
from swmath2swh.convertSoftware_from_json_toXml import convert_json_to_xml
import defusedxml.ElementTree as DET

import pandas as pd
import subprocess
import time
import tempfile
import os
import requests
import re

env = os.environ.copy()
env['SWMATH_USER_DEPOSIT'] = os.getenv('SWMATH_USER_DEPOSIT')
env['SWMATH_PWD_DEPOSIT'] = os.getenv('SWMATH_PWD_DEPOSIT')
env['SWMATH_PWD_DEPOSIT'] = os.getenv('SWMATH_PWD_DEPOSIT')
xsl_filename = '../../xslt/software/xslt_SWH_deposit.xslt'

r = requests.get("https://oai.staging.mardi4nfdi.org/oai/OAIHandler?verb=GetRecord&metadataPrefix=codemeta&identifier=oai:swmath.org:4532")
xml_str = r.content
dom = DET.fromstring(xml_str)
formatted_newdom = DET.tostring(dom, encoding='unicode')
def replace_namespace_prefixes(xml_str, new_prefix='codemeta'):
    updated_xml = re.sub(r'ns\d+:', f'{new_prefix}:', xml_str)
    return updated_xml
final_xml = replace_namespace_prefixes(formatted_newdom, new_prefix='codemeta')


print(final_xml)

#print(formatted_newdom)
#print(xml_str)

with tempfile.NamedTemporaryFile(mode='w', delete=False, suffix='.xml') as temp_file:
    temp_file.write(final_xml)
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

