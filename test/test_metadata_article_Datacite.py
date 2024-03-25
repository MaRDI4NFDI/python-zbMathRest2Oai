import unittest
import sys
print(sys.path)
import os
import lxml.etree as ET
from xmldiff import main
from xmldiff.actions import MoveNode

os.chdir(r"C:\Users\smm\PycharmProjects\python-zbMathRest2Oai")
class PlainXmlTest(unittest.TestCase):
    def test_similarity(self):

        print(os.getcwd())
        dom = ET.parse(r'test\data\articles\plain.xml')  #wthat is dom  plain.xml
        print("input XML Document" , dom)
        xslt = ET.parse(r'xslt\articles\xslt-article-Datacite.xslt')  #Datacite xslt
        print("here is xslt " , xslt)
        transform = ET.XSLT(xslt) # is it a reserved word
        newdom = transform(dom)
        if newdom.getroot().attrib.get('{http://www.w3.org/2001/XMLSchema-instance}schemaLocation') is None:
            newdom.getroot().attrib[
                '{http://www.w3.org/2001/XMLSchema-instance}schemaLocation'] = "http://datacite.org/schema/kernel-4 http://schema.datacite.org/meta/kernel-4/metadata.xsd"

        real_string = ET.tostring(newdom, pretty_print=True, encoding='utf8').decode()
        print("Transformed XML:", real_string)
        # print(ET.tostring(newdom, pretty_print=True, xml_declaration=True, encoding='utf8').decode())
        expected_dom = ET.parse(r'test\data\articles\Test_Reference.xml')

        expected_string = ET.tostring(ET.parse(r'test\data\articles\Test_Reference.xml')) #my Test_Reference  still needs a tiny work
        print("Expected XML:", expected_string)
        diff = main.diff_texts(expected_string, real_string, {
            'ratio_mode': 'fast', # is that for latency
            'F': 1,
        })
        essentials = list(filter(lambda e: not isinstance(e, MoveNode), diff))
        print("Essential differences: = " , essentials)

        self.assertLessEqual(len(essentials), 0 , "Found differences between expected and transformed XML")  #and actually for the equality here



if __name__ == '__main__':
    unittest.main()