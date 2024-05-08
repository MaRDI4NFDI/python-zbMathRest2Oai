import json

import requests
import os

from requests.auth import HTTPBasicAuth

from zbmath_rest2oai import getAsXml


def write_oai(api_source, prefix):
    test_xml = getAsXml.final_xml2(api_source)
    for identifier in test_xml.keys():
        ingestFormat = "zbmath_rest_api"
        if prefix.startswith('oai:swmath.org:'):
            ingestFormat = 'datacite_swmath'
            print(ingestFormat)
            print(prefix+str(identifier))
        files = {"item": (None, json.dumps({"identifier": prefix+str(identifier),"deleteFlag": False,"ingestFormat": ingestFormat,}),"application/json",),"content": (None, test_xml[identifier]),}
        basic = HTTPBasicAuth('swmath', os.environ.get('OAI_BASIC_PASSWORD'))
        x = requests.post("http://oai-input.portal.mardi4nfdi.de/oai-backend/item", files=files, auth=basic)
        if x.status_code == 409:
            continue
        elif x.status_code != 200:
            raise Exception(f"Unexpected response with status code {x.status_code}: {x.text}")
        else:
            return x.text


if __name__ == '__main__':
    import sys
    write_oai(sys.argv[1], sys.argv[2])
