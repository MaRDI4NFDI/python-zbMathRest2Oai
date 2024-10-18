import unittest

from zbmath_rest2oai.getAsXml import apply_zbmath_api_fixes


class ZbmathFixes(unittest.TestCase):
    def test_datestamp(self):
        test_obj = {'datestamp': '0001-01-01T00:00:00Z'}
        apply_zbmath_api_fixes(test_obj, '')
        self.assertEqual(test_obj['datestamp'], '0001-01-01T00:00:00')


if __name__ == '__main__':
    unittest.main()
