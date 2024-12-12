from swmath2swh.restApi_software_Json import process_metadata
from swmath2swh.convertSoftware_from_json_toXml import convert_json_to_xml
import defusedxml.ElementTree as DET  # Using defusedxml for safe XML parsing
from defusedxml.lxml import fromstring
import lxml.etree as ET
import pandas as pd
import subprocess
import time
import tempfile
import os
import requests
import re
# Load environment variables
env = os.environ.copy()
env['SWMATH_USER_DEPOSIT'] = os.getenv('SWMATH_USER_DEPOSIT')
env['SWMATH_PWD_DEPOSIT'] = os.getenv('SWMATH_PWD_DEPOSIT')

xsl_filename = '../../xslt/software/xslt_SWH_deposit.xslt'

# Fetch XML data
r = requests.get("https://oai.staging.mardi4nfdi.org/oai/OAIHandler?verb=GetRecord&metadataPrefix=codemeta&identifier=oai:swmath.org:4532")
xml_str = r.content

dom = DET.fromstring(xml_str)

# Convert the defusedxml-parsed XML to a string for lxml processing
dom_str = DET.tostring(dom, encoding='unicode')

# Use lxml to parse the XML string for XSLT transformation
lxml_dom = fromstring(dom_str)

# Perform XSLT transformation using lxml
xslt = ET.parse(xsl_filename)
transform = ET.XSLT(xslt)
newdom = transform(lxml_dom)
formatted_newdom = ET.tostring(newdom, pretty_print=True, encoding='unicode')
formatted_newdom = re.sub(r'xmlns:ns\d+="[^"]+"', '', formatted_newdom)
formatted_newdom = re.sub(r'ns\d+:', 'codemeta:', formatted_newdom)
print(formatted_newdom)

# Write transformed XML to a temporary file
with tempfile.NamedTemporaryFile(mode='w', delete=False, suffix='.xml') as temp_file:
    temp_file.write(formatted_newdom)
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
