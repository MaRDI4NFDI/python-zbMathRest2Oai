import unittest

import requests

from zbmath_rest2oai.getAsXml import extract_tags

class PlainXmlTest(unittest.TestCase):
    @staticmethod
    def test_jfm_doc():
        headers = {'Accept': 'application/json'}
        r = requests.get(
            'https://api.zbmath.org/v1/document/_structured_search?page=0&results_per_page=10&zbmath%20id=2500495',
            headers=headers)
        real_tags = extract_tags(r.json()['result'][0])
        assert real_tags == ['11', 'JFM', 'datacite']

    @staticmethod
    def test_software():
        headers = {'Accept': 'application/json'}
        r = requests.get(
            'https://api.zbmath.org/v1/software/12',
            headers=headers)
        real_tags = extract_tags(r.json()['result'])
        assert real_tags == ['60', '65', '78', '82', 'openaire']



if __name__ == '__main__':
    unittest.main()
