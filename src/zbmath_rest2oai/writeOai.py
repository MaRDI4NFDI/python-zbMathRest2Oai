import json

import requests
import os

from requests.auth import HTTPBasicAuth

from zbmath_rest2oai import getAsXml


def write_oai(x):
    test_xml = getAsXml.final_xml2(x)
    files = {
        "item": (
            None,
            json.dumps(
                {
                    "identifier": x,
                    "deleteFlag": False,
                    "ingestFormat": "zbmath_rest_api",
                }
            ),
            "application/json",
        ),
        "content": (None, test_xml),
    }
    basic = HTTPBasicAuth('swmath', os.environ.get('OAI_BASIC_PASSWORD'))
    x = requests.post("http://oai-input.portal.mardi4nfdi.de/oai-backend/item", files=files, auth=basic)
    if x.status_code != 200:
        raise Exception(f"Unexpected response with status code {x.status_code}: {x.text}")
    else:
        return x.text
