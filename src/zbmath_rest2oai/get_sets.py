import requests

URL = 'https://api.zbmath.org/v1/classification/_search?search_string=lv%3A0'


def get_sets():
    headers = {'Accept': 'application/json'}
    r = requests.get(URL, headers=headers)
    results = r.json()['result']
    mscs = {'JFM': 'JFM: Jahrbuch für Mathematik',
            'openaire': 'openaire Required set for OpenAIRE, cf.'
                        + 'https://guidelines.openaire.eu/en/latest/literature'
                        + '/use_of_oai_pmh.html',
            'datacite': 'Datacite: for metadata supported with Doi and arXiv identifiers'}
    for result in results:
        code = result['code'][:2]
        mscs[code] = code + '-XX:' + result['short_title']
    return mscs


if __name__ == '__main__':
    print(get_sets())
