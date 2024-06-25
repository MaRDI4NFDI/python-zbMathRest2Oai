import sys

from zbmath_rest2oai.writeOai import write_oai


def get_all_de(api_source, prefix):
    try:
        write_oai(api_source, prefix, 'radar')
    except Exception as error:
        print(error, file=sys.stderr)
