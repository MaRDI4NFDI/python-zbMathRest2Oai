import dict2xml
import requests
import sys

def final_xml2(api_source):

    headers = {'Accept': 'application/json'}
    r = requests.get(api_source, headers=headers)
    if r.status_code != 200:
        raise Exception(f"Unexpected response with status code {r.status_code}: {r.text}")
    json = r.json()
    dict_math_entities= dict()
    for i in range(len(json["result"])):
        dict_math_entities[json["result"][i]["id"]]=dict2xml.Converter(wrap="root").build(json["result"][i], closed_tags_for=[[], '', [None], None])
    #print(dict_math_entities)
    # Bugfix as the sates are lists of lists which has no canonical XML mapping`
    # End of fix
    return dict_math_entities
    

if __name__ == "__main__":
    final_xml2(sys.argv[1])

