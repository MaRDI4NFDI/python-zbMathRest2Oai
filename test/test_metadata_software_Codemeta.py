import unittest
import os

import lxml.etree as ET

from xmldiff import main
from xmldiff.actions import MoveNode

if os.path.basename(os.getcwd()) == 'test':
    os.chdir(os.path.dirname(os.getcwd()))



    class Sagemath_PlainXml(unittest.TestCase):
          def TestSimilarity(self):
            dom = ET.parse('test/data/software/Sagemath_plain.xml')
            xslt = ET.parse('xslt/software/xslt-software-Codemeta.xslt')

            transform = ET.XSLT(xslt)
            newdom = transform(dom)

            real_string = ET.tostring(newdom , pretty_print= True , encoding= 'utf8').decode()

            reference = ET.parse('test/data/software/Sagemath_plain.xml')

            expected_string = ET.tostring(reference , pretty_print=True , encoding= 'utf8').decode()

            diff = main.diff_texts(expected_string , real_string,
             {'ratie mode' : 'fast'
               , 'ratio' : 1, })

            essentials = list(filter(lambda e : not isinstance(e , MoveNode), diff))

            self.assertEqual(len(essentials), 0 , "Found differences between expected and transformed XML")


    if __name__ == '__main__':
       unittest.main()
