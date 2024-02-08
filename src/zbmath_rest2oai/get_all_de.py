import sys

import requests
import csv

from zbmath_rest2oai.writeOai import write_oai

# from https://stackoverflow.com/a/38677619/9215209


def get_all_de(api_source,CSV_URL):
    with requests.get(CSV_URL, stream=True) as r:
        lines = (line.decode('utf-8') for line in r.iter_lines())
        for row in csv.reader(lines):
            de = row[0]
            try:
                write_oai(de,api_source)
            except Exception as error:
                print(de, error, file=sys.stderr)


