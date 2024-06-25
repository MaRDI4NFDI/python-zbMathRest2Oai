from dict2xml import Converter
import requests
import sys


def apply_zbmath_api_fixes(result, prefix):
    if result.get('datestamp'):
        result['datestamp'] = (result['datestamp'].
                               replace('0001-01-01T00:00:00Z', '0001-01-01T00:00:00'))

    if result.get('id'):
        result['id'] = prefix + str(result['id'])
    old_states = result.get('states')
    if old_states is None:
        return
    states = {}
    for lst in old_states:
        [k, v] = lst
        states[k] = v
    result['states'] = states


def final_xml2(api_source,prefix):
    headers = {'Accept': 'application/json'}
    r = requests.get(api_source, headers=headers)
    if r.status_code != 200:
        raise Exception(f"Unexpected response with status code {r.status_code}: {r.text}")
    json = r.json()
    dict_math_entities = dict()
    with open('last_id.txt', 'a') as f:
        f.write(';' + str(json['status']['last_id']))
        f.close()
    for result in json["result"]:
        apply_zbmath_api_fixes(result, prefix)
        dict_math_entities[result["id"]] = Converter(wrap="root").build(
            result,
            closed_tags_for=[[], '', [None], None])
    return dict_math_entities


if __name__ == "__main__":
    final_xml2(sys.argv[1])
