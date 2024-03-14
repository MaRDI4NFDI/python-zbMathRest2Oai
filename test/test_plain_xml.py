import os
import unittest

from xmldiff import main
from xmldiff.actions import MoveNode

from zbmath_rest2oai import getAsXml

API_SOURCE = 'https://api.zbmath.org/v1/document/_structured_search?page=0&results_per_page=10&zbmath%20id=6383667'


class PlainXmlTest(unittest.TestCase):
    def test_similarity(self):
        real_string = getAsXml.final_xml2(API_SOURCE)[6383667]

        ref_location = os.path.join(os.path.dirname(__file__), 'data/articles/plain.xml')
        with open(ref_location) as f:
            expected_string = f.read()
            diff = main.diff_texts(expected_string, real_string, {
                'ratio_mode': 'fast',
                'F': 1,
            })
            essentials = list(filter(lambda e: not isinstance(e, MoveNode), diff))
            self.assertLessEqual(len(essentials), 0)


if __name__ == '__main__':
    unittest.main()
