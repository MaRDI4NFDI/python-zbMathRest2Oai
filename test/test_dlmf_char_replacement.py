import unittest

class TestLinkReplacement(unittest.TestCase):

    def test_link_replacement(self):
        # Sample input (mock data)
        result = {
            'links': [
                {"type": "dlmf", "url": "https://dlmf.nist.gov/25.2#E11.info"},
            ]
        }

        # Function to replace the links (as per your code)
        replace_tup = (('#', '.'), ('.info', ''), ('https', 'http'))

        # Process the links
        if result.get('links'):
            for dic in result.get('links'):
                if dic["type"] == "dlmf":
                    for tup in replace_tup:
                        dic["url"] = dic["url"].replace(*tup)
        
        # Expected output after transformation
        expected_result = [
            {"type": "dlmf", "url": "http://dlmf.nist.gov/25.2.E11"},
        ]

        # Assert the links are transformed as expected
        self.assertEqual(result['links'], expected_result)


if __name__ == '__main__':
    unittest.main()
