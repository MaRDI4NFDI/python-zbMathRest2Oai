from zbmath_rest2oai.get_all import get_all

# For production, use: oai_url = "https://oai-input.portal.mardi4nfdi.de/oai-backend/item"


get_all(
    prefix='oai:swmath.org:',
    url='https://api.zbmath.org/v1/software/_all?start_after={0}&results_per_request=500',
    oai_url='https://oai-input.staging.mardi4nfdi.org/oai-backend/item',
    ingest_format='zbmath_rest_api_software',
    state_property='software'
)
