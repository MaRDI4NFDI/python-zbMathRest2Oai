from dict2xml import Converter
import requests
import sys


def final_xml2(api_source):
    headers = {'Accept': 'application/json'}
    r = requests.get(api_source, headers=headers)
    if r.status_code != 200:
        raise Exception(f"Unexpected response with status code {r.status_code}: {r.text}")
    json = r.json()
    dict_math_entities = dict()
    for result in json["result"]:
        dict_math_entities[result["id"]] = Converter(wrap="root").build(
            result,
            closed_tags_for=[[], '', [None], None])
    return dict_math_entities


if __name__ == "__main__":
    final_xml2(sys.argv[1])
