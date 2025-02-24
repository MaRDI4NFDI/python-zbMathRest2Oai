import unittest
from zbmath_rest2oai.getAsXml import apply_zbmath_api_fixes

class TestLinkReplacement(unittest.TestCase):

    def test_link_replacement(self):
        # Sample input (mock data)
        result = {
            'links': [
                {"type": "dlmf", "url": "https://dlmf.nist.gov/25.2#E11.info"},
            ]
        }
        apply_zbmath_api_fixes(result, '')
        
        # Expected output after transformation
        expected_result = [
            {"type": "dlmf", "url": "http://dlmf.nist.gov/25.2.E11"},
        ]

        # Assert the links are transformed as expected
        self.assertEqual(result['links'], expected_result)


if __name__ == '__main__':
    unittest.main()
