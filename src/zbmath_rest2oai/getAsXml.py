import dict2xml


def final_xml2(de):
    import requests

    headers = {'Accept': 'application/json'}

    r = requests.get('https://api.zbmath.org/v1/document/' + de, headers=headers)

    return dict2xml.Converter(wrap="root").build(r.json(), closed_tags_for=[[], '', [None], None])


print(final_xml2("6383667"))
