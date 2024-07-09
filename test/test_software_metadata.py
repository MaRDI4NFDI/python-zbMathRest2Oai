import os
import unittest

from xmldiff import main
from xmldiff.actions import MoveNode

from zbmath_rest2oai import getAsXml

API_SOURCE = 'https://api.zbmath.org/v1/software/_search?search_string=si%3A2'


class PlainXmlTest(unittest.TestCase):
    def test_similarity(self):
        real_string = getAsXml.final_xml2(API_SOURCE,'')[0]['2']
        real_string = [line for line in real_string.splitlines() if line.strip() != '']
        real_string = '\n'.join(real_string)
        ref_location = os.path.join(os.path.dirname(__file__), 'data/software/plain.xml')
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