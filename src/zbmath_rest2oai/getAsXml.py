import dict2xml


def final_xml2(de):
    import requests

    headers = {'Accept': 'application/json'}

    r = requests.get('https://api.zbmath.org/v1/document/' + de, headers=headers)
    json = r.json()
    states = {}
    for lst in json['result']['states']:
        [k, v] = lst
        states[k] = v
    json['result']['states'] = states
    return (
        dict2xml.Converter(wrap="root")
        .build(json, closed_tags_for=[
            [], '', [None], None
        ])
    )