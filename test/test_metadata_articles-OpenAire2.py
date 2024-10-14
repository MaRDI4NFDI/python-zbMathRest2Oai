import os
import re
import unittest

import lxml.etree as ET
from xmldiff import main
from xmldiff.actions import MoveNode

if os.path.basename(os.getcwd()) == 'test':
    os.chdir(os.path.dirname(os.getcwd()))


# Function to split DOI into parts
def split_doi(doi):
    # Define regular expression patterns for various DOI formats
    doi_patterns = [
        r"(10\.\d{4,}/\S+)",
        r"(/?\S+)",  # For DOIs without prefix
    ]

    # Iterate through patterns to find a match
    for pattern in doi_patterns:
        match = re.match(pattern, doi)
        if match:
            return match.group(1), doi.replace(match.group(1), '', 1).lstrip('/')
    return None, None


class PlainXmlTest(unittest.TestCase):
    def test_similarity(self):


        dom = ET.parse('test/data/articles/plain.xml')
        xslt = ET.parse('xslt/articles/xslt-article-OpenAire2.xslt')

        transform = ET.XSLT(xslt)  # is it a reserved word
        newdom = transform(dom)

        real_string = ET.tostring(newdom, pretty_print=True, encoding='utf8').decode()
        # test if result is parsable
        reference = ET.parse('test/data/articles/reference-OpenAire2.xml')

        expected_string = ET.tostring(reference, pretty_print=True, encoding='utf8').decode()
        diff = main.diff_texts(expected_string, real_string, {
            'ratio_mode': 'fast',  # is that for latency
            'F': 1,
        })

        essentials = list(filter(lambda e: not isinstance(e, MoveNode), diff))

        self.assertLessEqual(len(essentials), 0, "Found differences between expected and transformed XML")


if __name__ == '__main__':
    unittest.main()

