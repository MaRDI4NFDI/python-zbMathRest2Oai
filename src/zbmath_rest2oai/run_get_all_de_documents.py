from zbmath_rest2oai.writeOai import write_oai

with open('last_de.txt', 'r') as handle:
    last_id = max(handle.read().split(';'))
    handle.close()

    while int(last_id) < 70000000:
        with open('last_de.txt', 'r') as f:
            last_id = str(max([int(x) for x in f.read().split(';')]))
            f.close()
            uri_request = 'https://api.zbmath.org/v1/document/_all?start_after={0}&results_per_request=500'.format(last_id)
            write_oai(api_source=uri_request, prefix='Zbl ')
