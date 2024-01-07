import os
import unittest
from xml.dom.minidom import parse
from xmldiff import main, formatting
from xmldiff.actions import MoveNode
from lxml import etree
from zbmath_rest2oai import getWithSwagger


class MyTestCase(unittest.TestCase):
    def test_something(self):
        real = getWithSwagger.get_final_xml("6383667")
        real_string = real.parentNode.parentNode.toprettyxml()
        ref_location = os.path.join(os.path.dirname(__file__), './data/reference.xml')
        with open(ref_location) as f:
            dom = parse(f)
            expected_string = dom.toprettyxml()
            diff = main.diff_texts(expected_string, real_string, {
                'ratio_mode': 'accurate'
            })
            essentials = list(filter(lambda e: not isinstance(e, MoveNode), diff))
            formatter = formatting.XMLFormatter()
            # parser = etree.XMLParser(remove_blank_text=True)
            # real_tree = etree.fromstring(expected_string, parser=parser)
            # for item in essentials:
            #      result = formatter.format([item], real_tree)
            #      print(result)
            self.assertLessEqual(len(essentials), 84)
            diff_text = main.diff_texts(expected_string, real_string, {
                'ratio_mode': 'accurate'
            }, formatter=formatter)
            print(diff_text)


if __name__ == '__main__':
    unittest.main()
