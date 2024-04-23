import sys
import os
sys.path.append(os.getcwd())

from zbmath_rest2oai import getAsXml


def write_local(api_source):
    xml = getAsXml.final_xml2(api_source)
    with open('temp_folder_software_metadata/{}.xml'.format(apisource), "wb") as f:
        f.write(xml)
        f.close()

if __name__ == '__main__':
    import sys
    write_local(sys.argv[1])