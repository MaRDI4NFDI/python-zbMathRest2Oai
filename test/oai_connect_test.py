import os
import unittest

if os.path.basename(os.getcwd()) == 'test':
    os.chdir(os.path.dirname(os.getcwd()))
import oai_connection


class PlainXmlTest(unittest.TestCase):
    def test_similarity(self):
        self.assertEqual("1.5.4", oai_connection.get_version())


if __name__ == '__main__':
    unittest.main()
