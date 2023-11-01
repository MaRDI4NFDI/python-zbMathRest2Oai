import requests

from zbmath_rest2oai.xml_writer import create_document

url = 'https://api.zbmath.org/document/6383667'

x = requests.get(url)

res = x.json()

print(create_document(res).toprettyxml())