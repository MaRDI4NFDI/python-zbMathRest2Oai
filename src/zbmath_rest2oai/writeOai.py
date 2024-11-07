import asyncio
import json
import os
from timeit import default_timer as timer

import aiohttp
from aiohttp import ClientSession

from zbmath_rest2oai import getAsXml

AUTH = aiohttp.BasicAuth('swmath', os.environ.get('OAI_BASIC_PASSWORD'))

URL = "https://oai-input.portal.mardi4nfdi.de/oai-backend/item"


async def sync_item(session, identifier, tags, ingest_format, content):
    data = aiohttp.FormData()
    data.add_field('item', json.dumps({
        "identifier": str(identifier),
        "deleteFlag": False,
        "tags": tags,
        "ingestFormat": ingest_format
    }), content_type='application/json')
    data.add_field('content', content, filename='dummy.xml')
    async with session.post(URL, data=data, auth=AUTH) as response:
        if response.status not in [200, 409]:
            raise Exception(f"Unexpected response with status code {response.status} for item {identifier}:"
                            f" {await response.text()}")
        return response


async def async_write_oai(xml_contents, ingest_format, tags=None):
    if tags is None:
        tags = {}
    tasks = []

    async with ClientSession() as session:
        last_id = -1
        records = 0
        for identifier in xml_contents.keys():
            records += 1
            last_id = identifier
            tasks.append(sync_item(
                session,
                identifier,
                tags.get(identifier, []),
                ingest_format,
                xml_contents[identifier]))

        await asyncio.gather(*tasks)

    return records, last_id


def write_oai(api_source, prefix, ingest_format):
    xml_contents, time_rest, tags = getAsXml.final_xml2(api_source, prefix)
    start = timer()
    records, last_id = asyncio.run(async_write_oai(xml_contents, ingest_format, tags))

    last_id = int(last_id.removeprefix(prefix))
    return {
        'last_id': last_id,
        'records': records,
        'time_rest': time_rest,
        'time_oai': timer() - start
    }


if __name__ == '__main__':
    import sys

    write_oai(sys.argv[1], sys.argv[2], 'zbmath_rest_api_software')
