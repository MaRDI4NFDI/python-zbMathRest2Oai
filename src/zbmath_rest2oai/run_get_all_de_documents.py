from zbmath_rest2oai.get_all_de import get_all_de

CSV_URL = 'https://github.com/MaRDI4NFDI/python-zbMathRest2Oai/releases/download/test/all_de_240115.csv'

if __name__ == '__main__':
    get_all_de('https://api.zbmath.org/v1/document/',CSV_URL)