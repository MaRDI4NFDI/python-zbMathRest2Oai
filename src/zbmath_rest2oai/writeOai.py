import json
import requests
import os

from requests.auth import HTTPBasicAuth
from zbmath_rest2oai import getAsXml

def write_oai(api_source, prefix, auth):
    test_xml = getAsXml.final_xml2(api_source)
    for identifier in test_xml.keys():
        files = {
            "item": (
                None,
                json.dumps({
                    "identifier": prefix + str(identifier),
                    "deleteFlag": False,
                    "ingestFormat": "zbmath_rest_api",
                }),
                "application/json",
            ),
            "content": (None, test_xml[identifier]),
        }
        print(auth)
        x = requests.post("http://oai-input.portal.mardi4nfdi.de/oai-backend/item", files=files, auth=auth)
        if x.status_code == 409:
            continue
        elif x.status_code != 200:
            raise Exception(f"Unexpected response with status code {x.status_code}: {x.text}")
        else:
            return x.text

if __name__ == '__main__':
    import sys
    print("Number of arguments:", len(sys.argv))
    print("Argument List:", str(sys.argv))
    if len(sys.argv) != 3:
        print("Usage: python writeOai.py <api_source> <prefix>")
        sys.exit(1)
    api_source = sys.argv[1]
    prefix = sys.argv[2]
    auth = ('swmath', '3Lye4iH5mdXcjDQipN9g')
    write_oai(api_source, prefix, auth)
