from zbmath_rest2oai.get_all import get_all

get_all(
        prefix='Zbl',
        url='https://api.zbmath.org/v1/document/_all?start_after={0}&results_per_request=500',
        ingest_format='zbmath_rest_api',
        state_property='last_document_id'
    )

