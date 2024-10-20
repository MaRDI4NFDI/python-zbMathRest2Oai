import asyncio
import json
import os

import aiohttp
from aiohttp import ClientSession

from zbmath_rest2oai.get_sets import get_sets

AUTH = aiohttp.BasicAuth('swmath', os.environ.get('OAI_BASIC_PASSWORD'))

URL = "https://oai-input.portal.mardi4nfdi.de/oai-backend/set/"


async def post_item(session, data, set_name='unknown'):
    async with session.post(URL,
                            data=data,
                            auth=AUTH,
                            headers={"Content-Type": "application/json"}) as response:
        if response.status not in [200, 409]:
            raise Exception(f"Unexpected response with status code {response.status} for set {set_name}:"
                            f" {await response.text()}")
        return response


async def async_write_oai(sets):
    tasks = []

    async with ClientSession() as session:
        last_id = -1
        records = 0
        for identifier in sets.keys():
            records += 1
            last_id = identifier
            data = {'name': identifier,
                    'spec': identifier,
                    'tags': [identifier],
                    'description': sets[identifier],
                    }

            tasks.append(post_item(session, json.dumps(data), identifier))

        await asyncio.gather(*tasks)

    return records, last_id


def write_oai_sets():
    asyncio.run(async_write_oai(get_sets(), ))


if __name__ == '__main__':
    write_oai_sets()
