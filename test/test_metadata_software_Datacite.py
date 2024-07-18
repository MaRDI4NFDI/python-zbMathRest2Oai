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
            xslt = ET.parse('xslt/software/xslt-software-Datacite.xslt')

            transform = ET.XSLT(xslt)  # is it a reserved word
            newdom = transform(dom)
            print(newdom) #this print is to see the result of the trnasformation when by running the test
            real_string = ET.tostring(newdom, pretty_print=True, encoding='utf8').decode()
            # test if result is parsable
            reference = ET.parse('test/data/software/reference.xml')

            expected_string = ET.tostring(reference, pretty_print=True, encoding='utf8').decode()
            diff = main.diff_texts(expected_string, real_string, {
                'ratio_mode': 'fast',  # is that for latency
                'F': 1,
            })
            essentials = list(filter(lambda e: not isinstance(e, MoveNode), diff))

            self.assertLessEqual(len(essentials), 0, "Found differences between expected and transformed XML")


    if __name__ == '__main__':
        unittest.main()