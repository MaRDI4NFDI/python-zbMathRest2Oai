import unittest

import requests

from zbmath_rest2oai.getAsXml import extract_tags

API_SOURCE = 'https://api.zbmath.org/v1/document/_structured_search?page=0&results_per_page=10&zbmath%20id=2500495'


class PlainXmlTest(unittest.TestCase):
    def test_similarity(self):
        headers = {'Accept': 'application/json'}
        r = requests.get(API_SOURCE, headers=headers)
        real_tags = extract_tags(r.json()['result'][0])
        assert real_tags == ['11', 'JFM']


if __name__ == '__main__':
    unittest.main()
