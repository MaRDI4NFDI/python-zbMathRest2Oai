
import os
import re
import unittest

import lxml.etree as ET
from xmldiff import main
from xmldiff.actions import MoveNode
from xml.dom.minidom import parse
from zbmath_rest2oai import getAsXml
dom = ET.parse('test/data/software/plain.xml')
xslt = ET.parse('xslt/software/xslt-software-transformation.xslt')
transform = ET.XSLT(xslt)
newdom = transform(dom)
real_string = str(newdom).replace('&','&amp;')
print(real_string)
class PlainXmlTest(unittest.TestCase):
    def test_similarity(self):

        ref_location = os.path.join(os.path.dirname(__file__), 'data/software/reference.xml')
        with open(ref_location) as f:
            dom = parse(f)
            expected_string = dom.toprettyxml()
            print(type(expected_string))
            diff = main.diff_texts(expected_string, real_string, {
                'ratio_mode': 'fast',
                'F': 1,
            })
            essentials = list(filter(lambda e: not isinstance(e, MoveNode), diff))
            self.assertLessEqual(len(essentials), 0)


if __name__ == '__main__':
    unittest.main()