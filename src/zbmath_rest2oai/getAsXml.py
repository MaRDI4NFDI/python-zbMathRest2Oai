import dict2xml
import requests


def final_xml2(api_source):

    headers = {'Accept': 'application/json'}
    r = requests.get(api_source, headers=headers)
    if r.status_code != 200:
        raise Exception(f"Unexpected response with status code {r.status_code}: {r.text}")
    json = r.json()
    # Bugfix as the sates are lists of lists which has no canonical XML mapping
    if type(json['result'])==dict:
        for ident in json['result'].keys():
            print(json['result'][ident])
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
