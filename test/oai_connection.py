import os

import requests
from requests.auth import HTTPBasicAuth


def get_version():
    basic = HTTPBasicAuth('swmath', os.environ.get('OAI_BASIC_PASSWORD'))
    res = requests.get('https://oai-input.portal.mardi4nfdi.de/oai-backend/info/version', auth=basic)
    return res.text
