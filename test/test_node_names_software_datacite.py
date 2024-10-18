import os
import unittest

import lxml.etree as ET
from xmldiff import main
from xmldiff.actions import MoveNode

if os.path.basename(os.getcwd()) == 'test':
    os.chdir(os.path.dirname(os.getcwd()))


class PlainXmlTest(unittest.TestCase):
    def test_similarity(self):
        dom = ET.parse('test/data/software/plain.xml')
        xslt = ET.parse('xslt/software/xslt-software-datacite.xslt')
        transform = ET.XSLT(xslt)
        newdom = transform(dom)
        real_string = ET.tostring(newdom, pretty_print=True, encoding='utf8').decode()

        expected_string = ET.tostring(ET.parse('test/data/software/reference.xml'))

        diff = main.diff_texts(expected_string, real_string, {
            'ratio_mode': 'fast',
            'F': 1,
        })
        essentials = list(filter(lambda e: not isinstance(e, MoveNode), diff))
        self.assertLessEqual(len(essentials), 0)


if __name__ == '__main__':
    unittest.main()
