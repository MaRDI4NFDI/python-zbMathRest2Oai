# python-zbMathRest2Oai

[![DeepSource](https://app.deepsource.com/gh/MaRDI4NFDI/python-zbMathRest2Oai.svg/?label=resolved+issues&show_trend=true&token=SovMnB53sVw8-JcWeL8YRnsG)](https://app.deepsource.com/gh/MaRDI4NFDI/python-zbMathRest2Oai/) [![SWH](https://archive.softwareheritage.org/badge/origin/https://github.com/MaRDI4NFDI/python-zbMathRest2Oai/)](https://archive.softwareheritage.org/browse/origin/?origin_url=https://github.com/MaRDI4NFDI/python-zbMathRest2Oai) [![Maintainability](https://api.codeclimate.com/v1/badges/88fa012874c78bfeb8bf/maintainability)](https://codeclimate.com/github/MaRDI4NFDI/python-zbMathRest2Oai/maintainability) [![Test Coverage](https://api.codeclimate.com/v1/badges/88fa012874c78bfeb8bf/test_coverage)](https://codeclimate.com/github/MaRDI4NFDI/python-zbMathRest2Oai/test_coverage)

Read data from the zbMATH Open API https://api.zbmath.org/docs and feed it to the OAI-PMH
server https://oai.portal.mardi4nfdi.de/oai/

Hint for a proper installation:

* navigate to the directory
* execute `pip install -e .`
* execute `pip install .[test]` to install the dependencies for the test

## Project Structure

- **`src/swmath2swh`**: Handles integration with [Software Heritage (SWH)](https://www.softwareheritage.org/).
- **`zbmath_rest2oai`**: Ingests metadata into the OAI-PMH server at [oai.portal.mardi4nfdi.de/oai/](https://oai.portal.mardi4nfdi.de/oai/).

## Deployment
The project is containerized and managed via [Portainer](https://portainer.portal.mardi4nfdi.de/#!/home).

## QuickStatements JSON export for software records

The module `zbmath_rest2oai.software_quickstatements` converts zbMath software
records into a custom JSON format consumed by the
[MathSearch QuickStatements job](https://github.com/MathSearch/MathSearch).

Two JSON files are produced, matching the two update phases described in
[MaRDIRoadmap issue #173](https://github.com/MaRDI4NFDI/MaRDIRoadmap/issues/173):

| File | Contents |
|------|----------|
| `software_quickstatements_metadata.json` | `qP13` (swMath id lookup), `Len` (label), `P29` (homepage), `P339` (source code), `P226_*` (MSC classifications), `P1458q13_*` (related software), `P286q1459_*` (standard articles) |
| `software_quickstatements_references.json` | `qP1451` (citing article lookup), `P1463q13` (software id) |

### Key conventions

- `qP<id>` – find the item whose property `P<id>` equals the value.
- `P<x>q<id>` – value is an external id looked up via property `P<id>`; result
  stored as a wikibase-item value of property `P<x>`.
- `L<lang>` / `D<lang>` – label / description in language `lang`.
- Multi-valued fields use `_1`, `_2`, … suffixes (the job strips `_N` suffixes where N is a digit sequence).

### CLI usage

```bash
# Export all software (paged, from id 0)
python -m zbmath_rest2oai.run_software_quickstatements

# Export a single software record (e.g. SageMath, swMath id 825)
python -m zbmath_rest2oai.run_software_quickstatements --id 825

# Only produce the metadata file
python -m zbmath_rest2oai.run_software_quickstatements --phase metadata

# Only produce the references file
python -m zbmath_rest2oai.run_software_quickstatements --phase references

# Write to a specific directory
python -m zbmath_rest2oai.run_software_quickstatements --output-dir /tmp/out
```

The existing XML/XSLT-based OAI-PMH pipeline is unaffected.

## Support
For inquiries, contact **[support@zbmath.org](mailto:support@zbmath.org)**.