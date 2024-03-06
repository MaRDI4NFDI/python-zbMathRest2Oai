from zbmath_rest2oai.get_all_de import get_all_de

#CSV_URL = 'https://raw.githubusercontent.com/MaRDI4NFDI/python-zbMathRest2Oai/main/src/zbmath_rest2oai/software.csv'
if __name__ == '__main__':
    #get_all_de('https://api.zbmath.org/v1/software/_search?search_string=si%3A',CSV_URL, 'oai:swmath.org:')
    get_all_de('https://api.zbmath.org/v1/software/_search?search_string=si%3A0-100&page=0&results_per_page=100', 'oai:swmath.org:')
    get_all_de('https://api.zbmath.org/v1/software/_search?search_string=si%3A100-200&page=0&results_per_page=100', 'oai:swmath.org:')