"""Tests for software_quickstatements JSON output."""

import json
import os
import unittest

from zbmath_rest2oai.software_quickstatements import (
    build_metadata_json,
    build_references_json,
    to_metadata_row,
    to_reference_rows,
)

DATA_DIR = os.path.join(os.path.dirname(__file__), "data", "software")


def load_fixture(name):
    with open(os.path.join(DATA_DIR, name)) as f:
        return json.load(f)


class TestToMetadataRow(unittest.TestCase):
    """Unit tests for to_metadata_row."""

    def test_basic_fields(self):
        result = {"id": 825, "name": "SageMath", "homepage": "https://www.sagemath.org/"}
        row = to_metadata_row(result)
        self.assertEqual(row["qP13"], "825")
        self.assertEqual(row["Len"], "SageMath")
        self.assertEqual(row["P29"], "https://www.sagemath.org/")

    def test_source_code(self):
        result = {"id": 1, "name": "Foo", "source_code": "https://github.com/foo/bar"}
        row = to_metadata_row(result)
        self.assertEqual(row["P339"], "https://github.com/foo/bar")

    def test_empty_source_code_omitted(self):
        result = {"id": 1, "name": "Foo", "source_code": ""}
        row = to_metadata_row(result)
        self.assertNotIn("P339", row)

    def test_empty_homepage_omitted(self):
        result = {"id": 1, "name": "Foo", "homepage": ""}
        row = to_metadata_row(result)
        self.assertNotIn("P29", row)

    def test_classifications_multi(self):
        result = {"id": 1, "name": "Foo", "classification": ["68", "11", "14"]}
        row = to_metadata_row(result)
        self.assertEqual(row["P226_1"], "68")
        self.assertEqual(row["P226_2"], "11")
        self.assertEqual(row["P226_3"], "14")

    def test_related_software_multi(self):
        result = {
            "id": 1,
            "name": "Foo",
            "related_software": [{"id": 10, "name": "A"}, {"id": 20, "name": "B"}],
        }
        row = to_metadata_row(result)
        self.assertEqual(row["P1458q13_1"], "10")
        self.assertEqual(row["P1458q13_2"], "20")

    def test_standard_articles_multi(self):
        result = {
            "id": 1,
            "name": "Foo",
            "standard_articles": [{"id": 100, "title": "T1"}, {"id": 200, "title": "T2"}],
        }
        row = to_metadata_row(result)
        self.assertEqual(row["P286q1459_1"], "100")
        self.assertEqual(row["P286q1459_2"], "200")

    def test_standard_articles_as_dict(self):
        """single standard_article returned as dict, not list."""
        result = {
            "id": 1,
            "name": "Foo",
            "standard_articles": {"id": 100, "title": "T1"},
        }
        row = to_metadata_row(result)
        self.assertEqual(row["P286q1459_1"], "100")

    def test_oai_prefix_stripped(self):
        result = {"id": "oai:swmath.org:825", "name": "SageMath"}
        row = to_metadata_row(result)
        self.assertEqual(row["qP13"], "825")

    def test_no_classifications_produces_no_p226(self):
        result = {"id": 1, "name": "Foo"}
        row = to_metadata_row(result)
        self.assertNotIn("P226_1", row)


class TestToReferenceRows(unittest.TestCase):
    """Unit tests for to_reference_rows."""

    def test_basic(self):
        result = {"id": 825, "references": [3000001, 3000002]}
        rows = to_reference_rows(result)
        self.assertEqual(len(rows), 2)
        self.assertEqual(rows[0], {"qP1451": "3000001", "P1463q13": "825"})
        self.assertEqual(rows[1], {"qP1451": "3000002", "P1463q13": "825"})

    def test_empty_references(self):
        result = {"id": 1, "references": []}
        rows = to_reference_rows(result)
        self.assertEqual(rows, [])

    def test_single_reference_as_int(self):
        result = {"id": 2, "references": 999}
        rows = to_reference_rows(result)
        self.assertEqual(rows, [{"qP1451": "999", "P1463q13": "2"}])

    def test_oai_prefix_stripped(self):
        result = {"id": "oai:swmath.org:5", "references": [42]}
        rows = to_reference_rows(result)
        self.assertEqual(rows[0]["P1463q13"], "5")


class TestBuildMetadataJson(unittest.TestCase):
    """Unit tests for build_metadata_json."""

    def test_structure(self):
        results = [{"id": 1, "name": "A"}, {"id": 2, "name": "B"}]
        output = build_metadata_json(results)
        self.assertIn("rows", output)
        self.assertEqual(len(output["rows"]), 2)
        self.assertEqual(output["rows"][0]["qP13"], "1")
        self.assertEqual(output["rows"][1]["qP13"], "2")


class TestBuildReferencesJson(unittest.TestCase):
    """Unit tests for build_references_json."""

    def test_structure(self):
        results = [
            {"id": 1, "references": [10, 11]},
            {"id": 2, "references": [20]},
        ]
        output = build_references_json(results)
        self.assertIn("rows", output)
        self.assertEqual(len(output["rows"]), 3)


class TestSageMath825Fixture(unittest.TestCase):
    """Integration test: verify deterministic JSON output for SageMath (id=825).

    The raw fixture (sagemath_825_raw.json) is compared against the expected
    output fixtures (sagemath_825_metadata.json, sagemath_825_references.json).
    """

    def setUp(self):
        self.raw = load_fixture("sagemath_825_raw.json")
        self.expected_meta = load_fixture("sagemath_825_metadata.json")
        self.expected_refs = load_fixture("sagemath_825_references.json")

    def test_metadata_matches_fixture(self):
        result = build_metadata_json([self.raw])
        self.assertEqual(result, self.expected_meta)

    def test_references_match_fixture(self):
        result = build_references_json([self.raw])
        self.assertEqual(result, self.expected_refs)

    def test_metadata_qp13_is_825(self):
        result = build_metadata_json([self.raw])
        self.assertEqual(result["rows"][0]["qP13"], "825")

    def test_metadata_label_is_sagemath(self):
        result = build_metadata_json([self.raw])
        self.assertEqual(result["rows"][0]["Len"], "SageMath")

    def test_metadata_homepage_present(self):
        result = build_metadata_json([self.raw])
        self.assertIn("P29", result["rows"][0])

    def test_metadata_source_code_present(self):
        result = build_metadata_json([self.raw])
        self.assertIn("P339", result["rows"][0])


if __name__ == "__main__":
    unittest.main()
