import requests

url = 'https://api.zbmath.org/document/6383667'

x = requests.get(url)

print(x.text)