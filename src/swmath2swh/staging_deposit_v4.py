import io

import defusedxml.ElementTree as DET  # Using defusedxml for safe XML parsing
from defusedxml.lxml import fromstring
import lxml.etree as ET
import subprocess
import time
import tempfile
import os
import requests
import re
from io import BytesIO
from pathlib import Path

deposited_software_file = Path("./deposited_software.txt")
# Load environment variables
env = os.environ.copy()
env['SWMATH_USER_DEPOSIT'] = os.getenv('SWMATH_USER_DEPOSIT')
env['SWMATH_PWD_DEPOSIT'] = os.getenv('SWMATH_PWD_DEPOSIT')

xsl_filename = './xslt/software/xslt_SWH_deposit.xslt'


def get_swmath_ids_from_oai():
    """Retrieve all SWMath IDs from the OAI-PMH SWH set"""
    OAI_URL = "https://oai.portal.mardi4nfdi.de/oai/OAIHandler"
    params = {
        "verb": "ListRecords",
        "metadataPrefix": "codemeta",
        "set": "SWH"
    }
    swmath_ids = []
    if deposited_software_file.is_file():
        with open(deposited_software_file, "r") as f:
            deposited_software = f.readlines()
            f.close()
    else:
        deposited_software = []


    while True:
        r = requests.get(OAI_URL, params=params)
        context = DET.iterparse(BytesIO(r.content), events=("end",))

        resumption_token = None

        for event, elem in context:
            tag = elem.tag.split("}")[-1]  # Remove namespace
            if tag == "identifier":
                # Extract SWMath ID from identifier (format: oai:swmath.org:123)
                if "oai:swmath.org:" in elem.text:
                    swmath_id = elem.text.split(":")[-1]
                    swmath_ids.append(swmath_id)
            elif tag == "resumptionToken":
                resumption_token = elem.text.strip() if elem.text else None
            elem.clear()

        if resumption_token:
            # Update params to fetch next page
            params = {
                "verb": "ListRecords",
                "resumptionToken": resumption_token
            }
        else:
            break

    return list(set(swmath_ids)-set(deposited_software))


def process_swmath_record(swmath_id):
    """Process a single SWMath record and deposit it"""
    # Fetch XML data
    r = requests.get(
        "https://oai.portal.mardi4nfdi.de/oai/OAIHandler?verb=GetRecord&metadataPrefix=codemeta&identifier=oai:swmath.org:{}".format(
            swmath_id))
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

    # Clean up XML formatting
    formatted_newdom = re.sub(r'xmlns:xsi="[^"]+"', '', formatted_newdom)
    formatted_newdom = re.sub(r'xmlns:ns\d+="[^"]+"', '', formatted_newdom)
    formatted_newdom = re.sub(r'ns\d+:', 'codemeta:', formatted_newdom)
    formatted_newdom = re.sub(r'<\s*([^>]+?)\s*>', r'<\1>', formatted_newdom)
    formatted_newdom = re.sub(r'<\s*/\s*([^>]+?)\s*>', r'</\1>', formatted_newdom)

    # Write transformed XML to a temporary file
    with tempfile.NamedTemporaryFile(mode='w', delete=False, suffix='.xml') as temp_file:
        temp_file.write(formatted_newdom)
        temp_filename = temp_file.name
        print(f"Temporary file created: {temp_filename}")

    # Format current time for deposit status
    current_time = time.localtime()
    formatted_time = time.strftime("%Y-%m-%d %H:%M:%S", current_time)
    dict_deposit = str({
        "deposit_id": str(swmath_id),
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
    if deposited_software_file.is_file():
        with open(deposited_software_file, "a") as f:
            f.write(str(swmath_id))
            f.close()
    else:
        with open(deposited_software_file, "w") as f:
            f.write(str(swmath_id))
            f.close()
    # Clean up temporary file
    os.unlink(temp_filename)


def main():
    print("Fetching SWMath IDs from OAI-PMH SWH set...")
    swmath_ids = get_swmath_ids_from_oai()
    print(f"Found {len(swmath_ids)} SWMath records to process")

    for i, swmath_id in enumerate(swmath_ids, 1):
        print(f"\nProcessing record {i}/{len(swmath_ids)} (ID: {swmath_id})")
        try:
            process_swmath_record(swmath_id)
            print(f"Successfully processed ID: {swmath_id}")
        except Exception as e:
            print(f"Error processing ID {swmath_id}: {str(e)}")


if __name__ == "__main__":
    main()