import sys

import requests
import csv

from zbmath_rest2oai.writeOai import write_oai

# from https://stackoverflow.com/a/38677619/9215209


def get_all_de(api_source, prefix):
    try:
        write_oai(api_source, prefix)
    except Exception as error:
        print(error, file=sys.stderr)


