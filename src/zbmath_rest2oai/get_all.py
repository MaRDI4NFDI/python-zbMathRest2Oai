from zbmath_rest2oai.state import State
from zbmath_rest2oai.writeOai import write_oai


def get_all(prefix, url, ingest_format, state_property):
    state = State()
    while True:
        uri_request = url.format(getattr(state, state_property))
        last_id = write_oai(api_source=uri_request, prefix=prefix, ingest_format=ingest_format)
        last_id = int(last_id.removeprefix(prefix))
        if last_id == -1:
            break
        setattr(state, state_property, last_id)