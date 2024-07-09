from zbmath_rest2oai.state import State
from zbmath_rest2oai.writeOai import write_oai


def get_all(prefix, url, ingest_format, state_property):
    state = State()
    while True:
        uri_request = url.format(state.get_setting(state_property))
        last_id = write_oai(api_source=uri_request, prefix=prefix, ingest_format=ingest_format)
        last_id = int(last_id.removeprefix(prefix))
        if last_id == -1:
            break
        state.update_setting(state_property, last_id)
