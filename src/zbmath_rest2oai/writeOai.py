import json
import urllib.parse

import requests
import os

from requests.auth import HTTPBasicAuth

from zbmath_rest2oai import getAsXml


def write_oai(api_source, prefix):
    test_xml = getAsXml.final_xml2(api_source, prefix)
    for identifier in test_xml.keys():
        files = {"item": (None, json.dumps({
            "identifier": str(identifier),
            "deleteFlag": False,
            "ingestFormat": "zbmath_rest_api"
        }), "application/json",), "content": (None, test_xml[identifier]), }
        basic = HTTPBasicAuth('swmath', os.environ.get('OAI_BASIC_PASSWORD'))
        str_ulr = "http://oai-input.portal.mardi4nfdi.de/oai-backend/item"
        x = requests.post(url=str_ulr, files=files, auth=basic)
        if x.status_code == 409:
            continue
        elif x.status_code != 200:
            raise Exception(f"Unexpected response with status code {x.status_code}: {x.text}")
        else:
            return x.text


if __name__ == '__main__':
    import sys

    write_oai(sys.argv[1], sys.argv[2])
