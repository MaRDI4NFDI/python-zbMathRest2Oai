import json
import os

import requests
from requests.auth import HTTPBasicAuth

from zbmath_rest2oai import getAsXml


def write_oai(api_source, prefix, ingest_format):
    last_id = -1
    records = 0
    test_xml, time_rest = getAsXml.final_xml2(api_source, prefix)
    time_oai = .0
    for identifier in test_xml.keys():
        records += 1
        files = {"item": (None, json.dumps({
            "identifier": str(identifier),
            "deleteFlag": False,
            "ingestFormat": ingest_format
        }), "application/json",), "content": (None, test_xml[identifier]), }
        basic = HTTPBasicAuth('swmath', os.environ.get('OAI_BASIC_PASSWORD'))
        str_ulr = "https://oai-input.portal.mardi4nfdi.de/oai-backend/item"
        x = requests.post(url=str_ulr, files=files, auth=basic)
        if x.status_code not in [200, 409]:
            raise Exception(f"Unexpected response with status code {x.status_code}: {x.text}")
        time_oai += x.elapsed.total_seconds()
        last_id = str(identifier)

    last_id = int(last_id.removeprefix(prefix))
    return {
            'last_id': last_id,
            'records': records,
            'time_rest': time_rest,
            'time_oai': time_oai
            }


if __name__ == '__main__':
    import sys

    write_oai(sys.argv[1], sys.argv[2], 'zbmath_rest_api_software')
