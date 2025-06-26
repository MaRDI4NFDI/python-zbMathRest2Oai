import os
import unittest

from xmldiff import main
from xmldiff.actions import MoveNode

from zbmath_rest2oai import getAsXml

API_SOURCE = 'https://api.zbmath.org/v1/document/_structured_search?page=0&results_per_page=10&zbmath%20id=6389213'


class PlainXmlTest(unittest.TestCase):
    def test_similarity(self):
        real_string = getAsXml.final_xml2(API_SOURCE, 'Zbl ')[0]['Zbl 6389213']
        print("real result",real_string)
        ref_location = os.path.join(os.path.dirname(__file__), '../../test/data/articles/invalid_chr.xml')
        with open(ref_location) as f:
            expected_string = f.read()
            print("expected result",expected_string)
            diff = main.diff_texts(expected_string, real_string, {
                'ratio_mode': 'fast',
                'F': 1,
            })
            print(diff)
            essentials = list(filter(lambda e: not isinstance(e, MoveNode), diff))
            self.assertLessEqual(len(essentials), 1)  # TODO: find a way to store trailing spaces


if __name__ == '__main__':
    unittest.main()
