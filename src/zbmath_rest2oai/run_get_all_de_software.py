from zbmath_rest2oai.writeOai import write_oai


### OLD CODE

#CSV_URL = 'https://raw.githubusercontent.com/MaRDI4NFDI/python-zbMathRest2Oai/main/src/zbmath_rest2oai/software.csv'
#if __name__ == '__main__':
    #get_all_de('https://api.zbmath.org/v1/software/_search?search_string=si%3A',CSV_URL, 'oai:swmath.org:')
#write_oai(api_source='https://api.zbmath.org/v1/software/_all?start_after=0&results_per_request=500', prefix='oai:swmath.org:')

###


with open('last_id.txt','r') as f:
    last_id = max(f.read().split(';'))
    f.close()


while int(last_id) < 70000:
    with open('last_id.txt', 'r') as f:
        last_id = str(max([int(x) for x in f.read().split(';')]))
        f.close()
        uri_request = 'https://api.zbmath.org/v1/software/_all?start_after={0}&results_per_request=500'.format(last_id)
        print(uri_request)
        write_oai(api_source=uri_request, prefix='oai:swmath.org:')
