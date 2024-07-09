from zbmath_rest2oai.state import State
from zbmath_rest2oai.writeOai import write_oai


def get_all(prefix, url, ingest_format, state_property):
    state = State()
    while True:
        uri_request = url.format(state.get_state_var(state_property))
        res = write_oai(api_source=uri_request, prefix=prefix, ingest_format=ingest_format)
        if res['last_id'] == -1:
            break
        state.update_state(state_property, res)
