import unittest

from zbmath_rest2oai.get_sets import get_sets


class PlainXmlTest(unittest.TestCase):
    @staticmethod
    def test_getSets():
        real_sets = get_sets()
        assert len(real_sets) == 67
        assert real_sets['14'] == '14-XX:Algebraic geometry'
