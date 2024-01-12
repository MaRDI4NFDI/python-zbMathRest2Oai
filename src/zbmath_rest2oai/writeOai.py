import json

import requests
import os

from requests.auth import HTTPBasicAuth
with open('final.xml', 'r') as f:
    testXML = f.read()

url = "https://www.w3schools.com/python/demopage.php"
files = {
    "item": (
        None,
        json.dumps(
            {
                "identifier": "10.5072/38231",
                "deleteFlag": False,
                "ingestFormat": "radar",
            }
        ),
        "application/json",
    ),
    "content": (None, testXML),
}
# x = requests.delete('http://localhost:8081/oai-backend/item/10.5072%2F38238')
#x = requests.post("http://localhost:8081/oai-backend/item", files=files)
basic = HTTPBasicAuth('swmath', os.environ.get('OAI_BASIC_PASSWORD'))
x = requests.post("http://oai-input.portal.mardi4nfdi.de/oai-backend/item", files=files , auth=basic)
print(x.text)

# x = requests.get('http://localhost:8081/oai-backend/item/10.5072%2F38236')

