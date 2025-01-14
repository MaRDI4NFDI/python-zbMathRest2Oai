import re
import sys

import requests
from dict2xml import Converter

# from https://stackoverflow.com/a/22273639

_illegal_unichrs = [(0x00, 0x08), (0x0B, 0x0C), (0x0E, 0x1F),

                    (0x7F, 0x84), (0x86, 0x9F),

                    (0xFDD0, 0xFDDF), (0xFFFE, 0xFFFF)]

if sys.maxunicode >= 0x10000:  # not narrow build

    _illegal_unichrs.extend([(0x1FFFE, 0x1FFFF), (0x2FFFE, 0x2FFFF),

                             (0x3FFFE, 0x3FFFF), (0x4FFFE, 0x4FFFF),

                             (0x5FFFE, 0x5FFFF), (0x6FFFE, 0x6FFFF),

                             (0x7FFFE, 0x7FFFF), (0x8FFFE, 0x8FFFF),

                             (0x9FFFE, 0x9FFFF), (0xAFFFE, 0xAFFFF),

                             (0xBFFFE, 0xBFFFF), (0xCFFFE, 0xCFFFF),

                             (0xDFFFE, 0xDFFFF), (0xEFFFE, 0xEFFFF),

                             (0xFFFFE, 0xFFFFF), (0x10FFFE, 0x10FFFF)])

_illegal_ranges = ["%s-%s" % (chr(low), chr(high))

                   for (low, high) in _illegal_unichrs]

_illegal_xml_chars_RE = re.compile(u'[%s]' % u''.join(_illegal_ranges))


class EntryNotFoundException(Exception):
    pass


def apply_zbmath_api_fixes(result, prefix_get_as_xml):
    if result.get('datestamp'):
        result['datestamp'] = (result['datestamp'].
                               replace('0001-01-01T00:00:00Z', '0001-01-01T00:00:00'))

    if result.get('id'):
        result['id'] = prefix_get_as_xml + str(result['id'])
    old_states = result.get('states')
    if old_states is None:
        return
    states = {}
    for lst in old_states:
        [k, v] = lst
        states[k] = v
    result['states'] = states


def extract_tags(result):
    tags = []
    for msc in result.get('msc', []):
        msc0 = msc['code'][:2]
        if msc0 not in tags:
            tags.append(msc0)
    for msc in result.get('classification', []):
        if msc not in tags:
            tags.append(msc)
    tags.sort()
    if result.get('database') == 'JFM':
        tags.append('JFM')
    return tags



def add_references_to_software(api_uri, dict_res):
    list_articles_ids_to_soft = []
    list_articles_ids_and_alter_ids_to_soft = []
    list_references_year_alt = []
    if "software" in api_uri:
        if api_uri.startswith("https://api.zbmath.org/v1/software/_all?start_after=")==False:
            soft_id=api_uri.split("/")[-1]
            def api_doc_endpoint(page):
                return requests.get("https://api.zbmath.org/v1/document/_structured_search?page={}&results_per_page=100&software%20id={}".format(page,soft_id))
            page=0
            while True:
                data = api_doc_endpoint(page).json()
                if data is None or "result" not in data or not data["result"]:
                    break

                list_ids=[]
                list_ids_and_alter = []
                for entry in data["result"]:
                    list_ids.append(entry["id"])
                    list_links = []
                    for alt_dic in entry["links"]:
                        if alt_dic["type"] == "doi":
                            list_links.append(alt_dic["identifier"])
                        elif alt_dic["type"] == "arxiv":
                            list_links.append(alt_dic["identifier"])

                    list_ids_and_alter.append(";".join([str(entry["id"])]+list_links))

                    if "datestamp" in entry:
                        year = entry["datestamp"][:4]
                        list_references_year_alt.append(year)

                list_articles_ids_to_soft.extend(list_ids)
                list_articles_ids_and_alter_ids_to_soft.extend(list_ids_and_alter)

                page+=1

        if isinstance(dict_res, dict):
            dict_res["references"] = list_articles_ids_to_soft
            # Wrap it in a list to make it iterable for your existing loop
            dict_res["references_alt"] = list_articles_ids_and_alter_ids_to_soft
            dict_res["references_year_alt"] = list_references_year_alt
            dict_res = [dict_res]

    return dict_res
def final_xml2(api_source, prefix_final_xml2):
    headers = {'Accept': 'application/json'}
    r = requests.get(api_source, headers=headers, timeout=(10, 60))
    if r.status_code == 404:
        json = r.json()
        if json['status']['execution'].startswith('Entry not found!'):
            raise EntryNotFoundException(Exception(r.text))
    if r.status_code != 200:
        raise Exception(f"Unexpected response with status code {r.status_code}: {r.text}")
    json = r.json()
    dict_math_entities = {}
    tags = {}
    if "software" in api_source:
        if isinstance(json["result"], dict):
            json["result"] = add_references_to_software(api_source, json["result"])
        elif isinstance(json["result"], list):
            for ent in range(len(json["result"])):
                soft_id = json["result"][ent]['id']
                json["result"][ent] = add_references_to_software("https://api.zbmath.org/v1/software/"+str(soft_id), json["result"][ent])
    for result in json["result"]:
        if isinstance(result, list):
            result = result[0]
            apply_zbmath_api_fixes(result, prefix_final_xml2)
            identifier = result["id"]
            dict_math_entities[identifier] = _illegal_xml_chars_RE.sub("", Converter(wrap="root").build(
                result,
                closed_tags_for=[[], '', [None], None]))
            tags[identifier] = extract_tags(result)
        elif isinstance(result, dict):  
            apply_zbmath_api_fixes(result, prefix_final_xml2)
            identifier = result["id"]
            dict_math_entities[identifier] = _illegal_xml_chars_RE.sub("", Converter(wrap="root").build(
                result,
                closed_tags_for=[[], '', [None], None]))
            tags[identifier] = extract_tags(result)
    return [dict_math_entities, r.elapsed.total_seconds(), tags]


if __name__ == "__main__":
    if "document" in sys.argv[1]:
        prefix_final_xml2="oai:zbmath.org:"
    else:
        prefix_final_xml2="oai:swmath.org:"
    print(final_xml2(sys.argv[1], prefix_final_xml2))
