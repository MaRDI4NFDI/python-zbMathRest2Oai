import unittest

import lxml.etree as ET
from xmldiff import main
from xmldiff.actions import MoveNode
# should i use the same imports

class PlainXmlTest(unittest.TestCase):
    def test_similarity(self):
        dom = ET.parse('test/data/software/plain.xml')  # wthat is dom
        xslt = ET.parse('xslt/articles/xslt-article-Datacite.xslt')
        transform = ET.XSLT(xslt) # is it a reserved word
        newdom = transform(dom)
        real_string = ET.tostring(newdom, pretty_print=True, encoding='utf8').decode()
        # print(ET.tostring(newdom, pretty_print=True, xml_declaration=True, encoding='utf8').decode())

        expected_string = ET.tostring(ET.parse('test/data/software/reference.xml')) # still needs a tiny work

        diff = main.diff_texts(expected_string, real_string, {
            'ratio_mode': 'fast', # is that for latency
            'F': 1,
        })
        essentials = list(filter(lambda e: not isinstance(e, MoveNode), diff))
        self.assertLessEqual(len(essentials), 0)  # and actually for the equality here


if __name__ == '__main__':
    unittest.main()