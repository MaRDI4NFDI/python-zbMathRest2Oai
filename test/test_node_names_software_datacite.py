
import os
import re
import unittest

import lxml.etree as ET
from xmldiff import main
from xmldiff.actions import MoveNode
from xml.dom.minidom import parse


expected_string1 = ET.tostring(ET.parse('test/data/software/reference.xml'))


class PlainXmlTest(unittest.TestCase):
    def test_similarity(self):
        dom = ET.parse('test/data/software/plain.xml')
        xslt = ET.parse('xslt/software/xslt-software-transformation.xslt')
        transform = ET.XSLT(xslt)
        newdom = transform(dom)
        real_string = ET.tostring(newdom, pretty_print=True).decode().replace('&', '&amp;')
        print(real_string)

        expected_string = ET.tostring(ET.parse('test/data/software/reference.xml'))

        diff = main.diff_texts(expected_string, real_string, {
            'ratio_mode': 'fast',
            'F': 1,
        })
        essentials = list(filter(lambda e: not isinstance(e, MoveNode), diff))
        self.assertLessEqual(len(essentials), 0)


if __name__ == '__main__':
    unittest.main()