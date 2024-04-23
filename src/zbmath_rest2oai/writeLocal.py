import json

import requests
import os

from requests.auth import HTTPBasicAuth

from zbmath_rest2oai import getAsXml


def write_oai(api_source):
    return getAsXml.final_xml2(api_source)
if __name__ == '__main__':
    import sys
    write_oai(sys.argv[1])