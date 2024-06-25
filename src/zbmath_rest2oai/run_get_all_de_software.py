from zbmath_rest2oai.writeOai import write_oai

with open('last_id.txt', 'r') as f:
    last_id = max(f.read().split(';'))
    f.close()

while int(last_id) < 70000:
    with open('last_id.txt', 'r') as f:
        last_id = str(max([int(x) for x in f.read().split(';')]))
        f.close()
        uri_request = 'https://api.zbmath.org/v1/software/_all?start_after={0}&results_per_request=500'.format(last_id)
        write_oai(api_source=uri_request, prefix='oai:swmath.org:',format='zbmath_rest_api_software')
