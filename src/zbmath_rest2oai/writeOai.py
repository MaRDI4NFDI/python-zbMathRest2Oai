import asyncio
import json
import os
from timeit import default_timer as timer

import aiohttp
from aiohttp import ClientSession

from zbmath_rest2oai import getAsXml

AUTH = aiohttp.BasicAuth('swmath', os.environ.get('OAI_BASIC_PASSWORD'))


def content_differs(current, content) -> bool:
    try:
        return content != current['content']['content']
    except TypeError:
        # Content is None
        return True


async def sync_item(session, identifier, oai_url, tags, ingest_format, content):
    async with session.get(oai_url + '/' + str(identifier) + '?content=true', auth=AUTH) as resp:
        if resp.status == 404:
            data = await format_data(content, identifier, ingest_format, tags)
            async with session.post(oai_url, data=data, auth=AUTH) as response:
                if response.status not in [200]:
                    raise Exception(f"Unexpected response with status code {response.status} for item {identifier}:"
                                    f" {await response.text()}")
                return response
        if resp.status == 200:
            current = await resp.json()
            if content_differs(current, content):
                data = await format_data(content, identifier, ingest_format, tags)
                async with session.put(oai_url + '/' + str(identifier), data=data, auth=AUTH) as response:
                    if response.status not in [200]:
                        raise Exception(f"Unexpected response with status code {response.status} for item {identifier}:"
                                        f" {await response.text()}")
                    return response
            else:
                # nothing was changed
                pass


async def format_data(content, identifier, ingest_format, tags):
    data = aiohttp.FormData()
    data.add_field('item', json.dumps({
        "identifier": str(identifier),
        "deleteFlag": False,
        "tags": tags,
        "ingestFormat": ingest_format
    }), content_type='application/json')
    data.add_field('content', content, filename='dummy.xml')
    return data


async def async_write_oai(xml_contents, oai_url, ingest_format, tags=None):
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
                oai_url,
                tags.get(identifier, []),
                ingest_format,
                xml_contents[identifier]))

        await asyncio.gather(*tasks)

    return records, last_id


def write_oai(api_source, oai_url, prefix, ingest_format):
    xml_contents, time_rest, tags = getAsXml.final_xml2(api_source, prefix)
    start = timer()
    records, last_id = asyncio.run(async_write_oai(xml_contents, oai_url, ingest_format, tags))

    last_id = int(last_id.removeprefix(prefix))
    return {
        'last_id': last_id,
        'records': records,
        'time_rest': time_rest,
        'time_oai': timer() - start
    }


if __name__ == '__main__':
    import sys
    api_source='https://api.zbmath.org/v1/document/_all?start_after=0&results_per_request=500'
    oai_url = 'https://oai-input.portal.mardi4nfdi.de/oai-backend/item'
    prefix='oai:zbmath.org:'
    ingest_format='zbmath_rest_api'
    write_oai(api_source, oai_url, prefix, ingest_format)
