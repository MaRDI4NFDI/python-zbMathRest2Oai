"""CLI: export software records from zbMath REST API as QuickStatements JSON.

Produces two output files (by default in the current directory):
  - software_quickstatements_metadata.json
  - software_quickstatements_references.json

Usage examples::

    # Export all software (paged, starting from id 0)
    python -m zbmath_rest2oai.run_software_quickstatements

    # Export a single software record by swMath id
    python -m zbmath_rest2oai.run_software_quickstatements --id 825

    # Only produce the metadata file
    python -m zbmath_rest2oai.run_software_quickstatements --phase metadata

    # Only produce the references file
    python -m zbmath_rest2oai.run_software_quickstatements --phase references

    # Write to a specific directory
    python -m zbmath_rest2oai.run_software_quickstatements --output-dir /tmp/out
"""

from __future__ import annotations

import argparse
import json
import os
import sys

import requests

from zbmath_rest2oai.software_quickstatements import build_metadata_json, build_references_json


_API_BASE = "https://api.zbmath.org/v1/software"
_DEFAULT_PAGE_SIZE = 500


def _fetch_software_by_id(sw_id: int) -> dict:
    """Fetch a single software record from the zbMath REST API."""
    url = f"{_API_BASE}/{sw_id}"
    headers = {"Accept": "application/json"}
    r = requests.get(url, headers=headers, timeout=(10, 60))
    r.raise_for_status()
    data = r.json()
    result = data.get("result")
    if isinstance(result, list) and result:
        return result[0]
    if isinstance(result, dict):
        return result
    raise ValueError(f"Unexpected result format for id {sw_id}: {data!r}")


def _iter_all_software(start_after: int = 0, page_size: int = _DEFAULT_PAGE_SIZE):
    """Yield software result dicts from the zbMath REST API (paged)."""
    cursor = start_after
    while True:
        url = f"{_API_BASE}/_all?start_after={cursor}&results_per_request={page_size}"
        headers = {"Accept": "application/json"}
        r = requests.get(url, headers=headers, timeout=(10, 120))
        r.raise_for_status()
        data = r.json()
        results = data.get("result", [])
        if not results:
            break
        for item in results:
            if isinstance(item, dict):
                yield item
                cursor = item.get("id", cursor)
        if len(results) < page_size:
            break


def _add_references(result: dict) -> dict:
    """Augment a software result dict with its citing articles.

    Mirrors the logic in :func:`zbmath_rest2oai.getAsXml.add_references_to_software`.
    """
    sw_id = result.get("id")
    if sw_id is None:
        return result

    references: list[int] = []
    page = 0
    while True:
        url = (
            f"https://api.zbmath.org/v1/document/_structured_search"
            f"?page={page}&results_per_page=100&software%20id={sw_id}"
        )
        r = requests.get(url, headers={"Accept": "application/json"}, timeout=(10, 60))
        r.raise_for_status()
        data = r.json()
        page_results = data.get("result", [])
        if not page_results:
            break
        for entry in page_results:
            references.append(entry["id"])
        page += 1

    result["references"] = references
    return result


def main(argv: list[str] | None = None) -> None:
    parser = argparse.ArgumentParser(
        description="Export zbMath software records as QuickStatements JSON."
    )
    parser.add_argument(
        "--id",
        type=int,
        metavar="SWMATH_ID",
        help="Export a single software record by its swMath id.",
    )
    parser.add_argument(
        "--start-after",
        type=int,
        default=0,
        metavar="ID",
        help="Start exporting records after this id (for full-dump mode). Default: 0.",
    )
    parser.add_argument(
        "--phase",
        choices=["metadata", "references", "all"],
        default="all",
        help=(
            "Which output file(s) to produce: 'metadata', 'references', or 'all'. "
            "Default: all."
        ),
    )
    parser.add_argument(
        "--output-dir",
        default=".",
        metavar="DIR",
        help="Directory to write output JSON files to. Default: current directory.",
    )
    parser.add_argument(
        "--no-references",
        action="store_true",
        help=(
            "Skip fetching citing articles for each software record. "
            "Useful when running with --phase metadata only."
        ),
    )
    args = parser.parse_args(argv)

    os.makedirs(args.output_dir, exist_ok=True)

    if args.id is not None:
        print(f"Fetching software id={args.id} …", file=sys.stderr)
        record = _fetch_software_by_id(args.id)
        if args.phase in ("references", "all") and not args.no_references:
            record = _add_references(record)
        results = [record]
    else:
        print("Fetching all software records …", file=sys.stderr)
        results = []
        for record in _iter_all_software(start_after=args.start_after):
            if args.phase in ("references", "all") and not args.no_references:
                record = _add_references(record)
            results.append(record)
            if len(results) % 100 == 0:
                print(f"  … {len(results)} records fetched", file=sys.stderr)

    print(f"Building JSON for {len(results)} record(s) …", file=sys.stderr)

    if args.phase in ("metadata", "all"):
        meta_path = os.path.join(args.output_dir, "software_quickstatements_metadata.json")
        meta_json = build_metadata_json(results)
        with open(meta_path, "w", encoding="utf-8") as f:
            json.dump(meta_json, f, indent=2, ensure_ascii=False)
        print(f"Wrote {meta_path}", file=sys.stderr)

    if args.phase in ("references", "all"):
        refs_path = os.path.join(args.output_dir, "software_quickstatements_references.json")
        refs_json = build_references_json(results)
        with open(refs_path, "w", encoding="utf-8") as f:
            json.dump(refs_json, f, indent=2, ensure_ascii=False)
        print(f"Wrote {refs_path}", file=sys.stderr)


if __name__ == "__main__":
    main()
