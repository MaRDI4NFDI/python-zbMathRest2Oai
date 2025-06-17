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

## Support
For inquiries, contact **[support@zbmath.org](mailto:support@zbmath.org)**.