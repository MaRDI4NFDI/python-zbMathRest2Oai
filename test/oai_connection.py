import os

import requests
from requests.auth import HTTPBasicAuth

def get_version():
    basic = HTTPBasicAuth(os.environ.get('OAI_BASIC_USER'), os.environ.get('OAI_BASIC_PASSWORD'))
    res = requests.get('https://oai-input.portal.mardi4nfdi.de/oai-backend/info/version', auth=basic)
    return res.text

print(get_version())
