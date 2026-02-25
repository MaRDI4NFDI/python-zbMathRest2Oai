"""Convert zbMath software records to QuickStatements JSON for MaRDI portal.

Produces two JSON output files:
- software_quickstatements_metadata.json: metadata rows (swmathID, label,
  homepage, source code, classifications, related software, standard articles)
- software_quickstatements_references.json: reference rows (one per article
  citing the software)

JSON schema::

    {"rows": [{"qP13": "825", "Len": "SageMath", "P29": "...", ...}, ...]}

Key conventions (matching MathSearch QuickStatements job):
- ``qP<id>`` – look up item whose property P<id> equals the value.
- ``P<x>q<id>`` – value is an external id looked up via property P<id>; result
  stored as wikibase-item value of property P<x>.
- ``L<lang>`` / ``D<lang>`` – label / description in that language.
- ``qal<P<id>`` – qualifier.
- Multi-valued fields use ``_1``, ``_2``, … suffixes (the job strips
  numeric suffixes).
"""

from __future__ import annotations

from typing import Any


def _add_multi(row: dict, key: str, values: list[Any]) -> None:
    """Add multi-valued fields with ``_1``, ``_2``, … suffixes.

    Does nothing when *values* is empty.
    """
    for i, val in enumerate(values, start=1):
        row[f"{key}_{i}"] = str(val)


def to_metadata_row(result: dict) -> dict:
    """Build a QuickStatements metadata row from a software result dict.

    Parameters
    ----------
    result:
        Raw software dict as returned by the zbMath REST API (the ``result``
        field), before or after ``apply_zbmath_api_fixes``.  If an OAI prefix
        has already been applied to ``id`` (e.g. ``"oai:swmath.org:825"``), the
        numeric part is extracted automatically.

    Returns
    -------
    dict
        A single row suitable for the ``rows`` list in the metadata JSON file.
    """
    raw_id = result.get("id", "")
    # Strip OAI prefix if present (e.g. "oai:swmath.org:825" → "825")
    sw_id = str(raw_id).split(":")[-1]

    row: dict = {"qP13": sw_id}

    name = result.get("name", "")
    if name:
        row["Len"] = str(name)

    homepage = result.get("homepage", "")
    if isinstance(homepage, str) and homepage.strip():
        row["P29"] = homepage.strip()

    source_code = result.get("source_code", "")
    if isinstance(source_code, str) and source_code.strip():
        row["P339"] = source_code.strip()

    classifications = result.get("classification", [])
    if isinstance(classifications, str):
        classifications = [classifications]
    _add_multi(row, "P226", classifications)

    related = result.get("related_software", [])
    if isinstance(related, dict):
        related = [related]
    rel_ids = [
        str(r["id"])
        for r in related
        if isinstance(r, dict) and r.get("id") is not None
    ]
    _add_multi(row, "P1458q13", rel_ids)

    std_articles = result.get("standard_articles", [])
    if isinstance(std_articles, dict):
        std_articles = [std_articles]
    std_ids = [
        str(a["id"])
        for a in std_articles
        if isinstance(a, dict) and a.get("id") is not None
    ]
    _add_multi(row, "P286q1459", std_ids)

    return row


def to_reference_rows(result: dict) -> list[dict]:
    """Build QuickStatements reference rows from a software result dict.

    One row is emitted per article that cites (or is cited by) the software.

    Parameters
    ----------
    result:
        Raw software dict (same format as for :func:`to_metadata_row`).

    Returns
    -------
    list[dict]
        List of rows for the references JSON file.
    """
    raw_id = result.get("id", "")
    sw_id = str(raw_id).split(":")[-1]

    references = result.get("references", [])
    if isinstance(references, (int, str)):
        references = [references]

    rows = []
    for ref_id in references:
        rows.append({"qP1451": str(ref_id), "P1463q13": sw_id})
    return rows


def build_metadata_json(results: list[dict]) -> dict:
    """Build the metadata QuickStatements JSON structure.

    Parameters
    ----------
    results:
        List of raw software result dicts.

    Returns
    -------
    dict
        ``{"rows": [...]}`` ready to be serialised with ``json.dumps``.
    """
    return {"rows": [to_metadata_row(r) for r in results]}


def build_references_json(results: list[dict]) -> dict:
    """Build the references QuickStatements JSON structure.

    Parameters
    ----------
    results:
        List of raw software result dicts.

    Returns
    -------
    dict
        ``{"rows": [...]}`` ready to be serialised with ``json.dumps``.
    """
    rows: list[dict] = []
    for r in results:
        rows.extend(to_reference_rows(r))
    return {"rows": rows}
