import os
import re
import unittest

from xmldiff import main
from xmldiff.actions import MoveNode

from zbmath_rest2oai import getAsXml


class PlainXmlTest(unittest.TestCase):
    def test_similarity(self):
        real_string = getAsXml.final_xml2("6383667", 'https://api.zbmath.org/v1/document/')
        real_string = re.sub(
            '<query_execution_time_in_seconds>0.\\d+</query_execution_time_in_seconds>',
            '<query_execution_time_in_seconds>0</query_execution_time_in_seconds>',
            real_string)
        real_string = re.sub(
            '<time_stamp>[\\d\\-: .]+</time_stamp>',
            '<time_stamp>0</time_stamp>',
            real_string)

        ref_location = os.path.join(os.path.dirname(__file__), './data/plain.xml')
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
