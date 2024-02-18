import json

import requests
import os

from requests.auth import HTTPBasicAuth

from zbmath_rest2oai import getAsXml
import sys

def write_oai(x, api_source):
    test_xml = getAsXml.final_xml2(x, api_source)
    return

if __name__ == '__main__':

    print(write_oai(sys.argv[1], sys.argv[2]))
