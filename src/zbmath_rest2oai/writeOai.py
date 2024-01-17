import json

import requests
import os

from requests.auth import HTTPBasicAuth

from zbmath_rest2oai import getAsXml

def write_oai(x):
    testXML = getAsXml.final_xml2(*x)

    url = "https://www.w3schools.com/python/demopage.php"
    files = {
        "item": (
            None,
            json.dumps(
                {
                    "identifier": "6383667",
                    "deleteFlag": False,
                    "ingestFormat": "radar",
                }
            ),
            "application/json",
        ),
        "content": (None, testXML),
    }
    # x = requests.delete('http://localhost:8081/oai-backend/item/10.5072%2F38238')
    #x = requests.post("http://localhost:8081/oai-backend/item", files=files)
    basic = HTTPBasicAuth('swmath', os.environ.get('OAI_BASIC_PASSWORD'))
    x = requests.post("http://oai-input.portal.mardi4nfdi.de/oai-backend/item", files=files , auth=basic)
    if r.status_code != 200:
        raise Exception(f"Unexpected response with status code {r.status_code}: {r.text}")
    else:
        return
    print(x.text)

# x = requests.get('http://localhost:8081/oai-backend/item/10.5072%2F38236')

