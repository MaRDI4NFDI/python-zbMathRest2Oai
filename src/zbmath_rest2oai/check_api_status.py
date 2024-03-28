import sys

import requests
import csv

rows = []

CSV_URL = 'https://github.com/MaRDI4NFDI/python-zbMathRest2Oai/releases/download/test/all_de_240115.csv'


def import_csv(url):
    with requests.get(url, stream=True) as r:
        lines = (line.decode('utf-8') for line in r.iter_lines())
        for row in csv.reader(lines):
            rows.append(row)

        for row in rows:
            process_row(row)


def process_row(row):
    headers = {'Accept': 'application/json'}
    de = row[0]
    r = requests.get('https://api.zbmath.org/v1/document/' + de, headers=headers)
    if r.status_code != 200:
        print(f"Unexpected response with status code {r.status_code} for de {de}: {r.text}")


if __name__ == '__main__':
    import_csv(CSV_URL)
