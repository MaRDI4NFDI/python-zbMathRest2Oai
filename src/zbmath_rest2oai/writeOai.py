import json
import os

from timeit import default_timer as timer
import asyncio
import aiohttp
from aiohttp import ClientSession

from requests.auth import HTTPBasicAuth

from zbmath_rest2oai import getAsXml


async def post_item(session, url, files, auth):
    async with session.post(url, data=files, auth=auth) as response:
        if response.status not in [200, 409]:
            raise Exception(f"Unexpected response with status code {response.status}: {await response.text()}")
        return response


async def async_write_oai(test_xml, ingest_format):
    tasks = []
    auth = aiohttp.BasicAuth('swmath', os.environ.get('OAI_BASIC_PASSWORD'))
    url = "https://oai-input.portal.mardi4nfdi.de/oai-backend/item"

    async with ClientSession() as session:
        last_id = -1
        records = 0
        for identifier in test_xml.keys():
            records += 1
            last_id = identifier
            data = aiohttp.FormData()
            data.add_field('item', json.dumps({
                "identifier": str(identifier),
                "deleteFlag": False,
                "ingestFormat": ingest_format
            }), content_type='application/json')
            data.add_field('content', test_xml[identifier], filename='dummy.xml')
            tasks.append(post_item(session, url, data, auth))

        await asyncio.gather(*tasks)

    return records, last_id


def write_oai(api_source, prefix, ingest_format):
    test_xml, time_rest = getAsXml.final_xml2(api_source, prefix)
    start = timer()
    records, last_id = asyncio.run(async_write_oai(test_xml, ingest_format))

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
