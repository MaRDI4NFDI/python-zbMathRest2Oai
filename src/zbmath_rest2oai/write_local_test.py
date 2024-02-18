from zbmath_rest2oai import getAsXml
import sys


if __name__ == '__main__':
    with open(sys.argv[3], 'w') as f:
        f.write(getAsXml.final_xml2(sys.argv[1], sys.argv[2]))
