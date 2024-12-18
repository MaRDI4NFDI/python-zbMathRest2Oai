from zbmath_rest2oai.get_all import get_all

# For production, use: oai_url = "https://oai-input.portal.mardi4nfdi.de/oai-backend/item"
# For stagiing, use: oai_url = "https://oai-input.staging.mardi4nfdi.org/oai-backend/item"

get_all(
    prefix='oai:zbmath.org:',
    url='https://api.zbmath.org/v1/document/_all?start_after={0}&results_per_request=500',
    oai_url='https://oai-input.portal.mardi4nfdi.de/oai-backend/item',
    ingest_format='zbmath_rest_api',
    state_property='document'
)
