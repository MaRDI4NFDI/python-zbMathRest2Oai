import unittest
import requests


def get_api_version(url):
    try:
        response = requests.get(url)
        response.raise_for_status()  # Raises HTTPError for bad responses
        openapi_data = response.json()
        # Extract the API version from the 'info' object
        return openapi_data.get('info', {}).get('version', 'Unknown version')
    except requests.RequestException as e:
        return f"Error fetching OpenAPI data: {e}"


class TestAPIVersion(unittest.TestCase):
    def test_api_version_matches(self):
        url = "https://api.zbmath.org/openapi.json"
        expected_version = "1.5.8"
        actual_version = get_api_version(url)
        self.assertEqual(actual_version, expected_version,
                         f"Expected API version {expected_version}, but got {actual_version}")


if __name__ == "__main__":
    unittest.main()
