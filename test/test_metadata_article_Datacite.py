import unittest
import sys
print(sys.path)
import os
import lxml.etree as ET
import re
from xmldiff import main
from xmldiff.actions import MoveNode

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

#os.chdir(r"C:\Users\smm\PycharmProjects\python-zbMathRest2Oai")
os.chdir("data")

home_dir = os.path.expanduser("~")
os.chdir(os.path.join(home_dir, "PycharmProjects", "python-zbMathRest2Oai"))
class PlainXmlTest(unittest.TestCase):
    def test_similarity(self):

        print(os.getcwd())
        dom = ET.parse(r'test\data\articles\plain.xml')  #wthat is dom  plain.xml
        print("input XML Document" , dom)
        xslt = ET.parse(r'xslt\articles\xslt-article-Datacite.xslt')  #Datacite xslt
        print("here is xslt " , xslt)

        # Preprocess DOI values before transformation
        for elem in dom.xpath("//references/doi"):
            if elem.text is not None:
                doi = elem.text.strip()
                doi_prefix, doi_suffix = split_doi(doi)
                if doi_prefix is not None:
                    elem.text = f"{doi_prefix}"
                    if doi_suffix:
                        elem.attrib["suffix"] = doi_suffix
        transform = ET.XSLT(xslt) # is it a reserved word
        print(transform)
        newdom = transform(dom)


        if newdom.getroot().attrib.get('{http://www.w3.org/2001/XMLSchema-instance}schemaLocation') is None:
            newdom.getroot().attrib[
                '{http://www.w3.org/2001/XMLSchema-instance}schemaLocation'] = "http://datacite.org/schema/kernel-4 http://schema.datacite.org/meta/kernel-4/metadata.xsd"

        real_string = ET.tostring(newdom, pretty_print=True, encoding='utf8').decode()
        print("Transformed XML:", real_string)
        # print(ET.tostring(newdom, pretty_print=True, xml_declaration=True, encoding='utf8').decode())
        expected_dom = ET.parse(r'test\data\articles\Test_Reference.xml')

        expected_string = ET.tostring(ET.parse(r'test\data\articles\Test_Reference.xml')) #my Test_Reference  still needs a tiny work
        print("\nExpected XML:", expected_string)
        diff = main.diff_texts(expected_string, real_string, {
            'ratio_mode': 'fast', # is that for latency
            'F': 1,
        })
        essentials = list(filter(lambda e: not isinstance(e, MoveNode), diff))
        print("\nEssential differences: = " , essentials)

        self.assertLessEqual(len(essentials), 0 , "Found differences between expected and transformed XML")  #and actually for the equality here



if __name__ == '__main__':
    unittest.main()