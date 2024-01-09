from dict2xml import dict2xml


def final_xml2(de):
    import requests

    headers = {'Accept': 'application/json'}

    r = requests.get('https://api.zbmath.org/v1/document/' + de, headers=headers)

    return dict2xml(r.json(), wrap='root', indent="   ")


print(final_xml2("6383667"))
