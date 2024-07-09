from zbmath_rest2oai.get_all import get_all

get_all(
        prefix='swmath',
        url='https://api.zbmath.org/v1/software/_all?start_after={0}&results_per_request=500',
        ingest_format='zbmath_rest_api_software',
        state_property='software'
    )

