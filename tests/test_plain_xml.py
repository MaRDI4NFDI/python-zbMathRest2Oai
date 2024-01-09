import os
import unittest
from xml.dom.minidom import parse
from xmldiff import main, formatting
from xmldiff.actions import MoveNode
from zbmath_rest2oai import getAsXml


class PlainXmlTest(unittest.TestCase):
    def test_similarity(self):
        real_string = getAsXml.final_xml2("6383667")
        ref_location = os.path.join(os.path.dirname(__file__), './data/plain.xml')
        with open(ref_location) as f:
            dom = parse(f)
            expected_string = dom.toprettyxml()
            diff = main.diff_texts(expected_string, real_string, {
                'ratio_mode': 'accurate'
            })
            essentials = list(filter(lambda e: not isinstance(e, MoveNode), diff))
            self.assertLessEqual(len(essentials), 46)
            diff_text = main.diff_texts(expected_string, real_string, {
                'ratio_mode': 'accurate'
            }, formatter=formatting.XMLFormatter(normalize=formatting.WS_BOTH))
            print(diff_text)


if __name__ == '__main__':
    unittest.main()
