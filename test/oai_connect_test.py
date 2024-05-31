import unittest
import os

if os.path.basename(os.getcwd())=='test':
    os.chdir(os.path.dirname(os.getcwd()))
import oai_connection


class PlainXmlTest(unittest.TestCase):
    def test_similarity(self):
        real_string = oai_connection.get_version()
        self.assertEqual("1.2.11", real_string)


if __name__ == '__main__':
    unittest.main()
