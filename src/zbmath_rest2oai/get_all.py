import os

from zbmath_rest2oai.getAsXml import EntryNotFoundException
from zbmath_rest2oai.state import State
from zbmath_rest2oai.writeOai import write_oai


def get_all(prefix, url, ingest_format, state_property):
    state = State(os.environ.get('OAI_STATE_PATH', 'state.json'))
    while True:
        uri_request = url.format(state.get_state_var(state_property))
        try:
            res = write_oai(api_source=uri_request, prefix=prefix, ingest_format=ingest_format)
        except EntryNotFoundException:
            break
        if res['last_id'] == -1:
            break
        state.update_state(state_property, res)
