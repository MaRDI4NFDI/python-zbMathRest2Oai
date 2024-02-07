import dict2xml
import requests


def final_xml2(de):

    headers = {'Accept': 'application/json'}

    r = requests.get('https://api.zbmath.org/v1/document/' + de, headers=headers)
    if r.status_code != 200:
        raise Exception(f"Unexpected response with status code {r.status_code}: {r.text}")
    json = r.json()
    # Bugfix as the sates are lists of lists which has no canonical XML mapping
    states = {}
    for lst in json['result']['states']:
        [k, v] = lst
        states[k] = v
    json['result']['states'] = states
    # End of fix
    return (
        dict2xml.Converter(wrap="root")
        .build(json, closed_tags_for=[
            # Bugfix for wired XML output such as the string None or </>
            [], '', [None], None
        ])
    )
