import json

import requests
import os

from requests.auth import HTTPBasicAuth

from zbmath_rest2oai import getAsXml


def write_oai(api_source):
    xml = getAsXml.final_xml2(api_source)
    with open('temp_folder_software_metadata/{}.xml'.format(apisource), "wb") as f:
        f.write(xml)
        f.close()

if __name__ == '__main__':
    import sys
    write_oai(sys.argv[1])