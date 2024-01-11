import json

import requests

with open('final.xml', 'r') as f:
    testXML = f.read()

url = "https://www.w3schools.com/python/demopage.php"
files = {
    "item": (
        None,
        json.dumps(
            {
                "identifier": "10.5072/38236",
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
x = requests.post("http://172.20.0.28:8081/oai-backend/item", files=files)
print(x.text)

# x = requests.get('http://localhost:8081/oai-backend/item/10.5072%2F38236')

