import unittest

from zbmath_rest2oai import oai_connection


class PlainXmlTest(unittest.TestCase):
    def test_similarity(self):
        real_string = oai_connection.get_version()
        self.assertEqual("1.2.8", real_string)


if __name__ == '__main__':
    unittest.main()
