import os
import unittest
from xml.dom.minidom import parse
from xmldiff import main
from zbmath_rest2oai import getWithSwagger


class MyTestCase(unittest.TestCase):
    def test_something(self):
        real = getWithSwagger.get_final_xml("6383667")
        real_string = real.parentNode.parentNode.toprettyxml()
        ref_location = os.path.join(os.path.dirname(__file__), './data/reference.xml')
        with open(ref_location) as f:
            dom = parse(f)
            expected_string = dom.toprettyxml()
            diff = main.diff_texts(expected_string, real_string)
            self.assertEqual(len(diff), 0)  # add assertion here


if __name__ == '__main__':
    unittest.main()
