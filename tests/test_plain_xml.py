import os
import unittest
import re
from xmldiff import main, formatting
from xmldiff.actions import MoveNode
from zbmath_rest2oai import getAsXml


class PlainXmlTest(unittest.TestCase):
    def test_similarity(self):
        real_string = getAsXml.final_xml2("6383667")
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
                'ratio_mode': 'accurate'
            })
            essentials = list(filter(lambda e: not isinstance(e, MoveNode), diff))
            self.assertLessEqual(len(essentials), 13)


if __name__ == '__main__':
    unittest.main()
