from zbmath_rest2oai.get_all_de import get_all_de

CSV_URL = 'https://github.com/MaRDI4NFDI/python-zbMathRest2Oai/blob/75d00a4dcd97684ae03dce7059c5c3d260bdf47c/src/zbmath_rest2oai/software.csv'

if __name__ == '__main__':
    get_all_de('https://api.zbmath.org/v1/document/',CSV_URL)