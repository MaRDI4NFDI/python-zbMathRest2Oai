import re
import sys

from zbmath_rest2oai import getAsXml

xml_string, _ = getAsXml.final_xml2(sys.argv[1], sys.argv[2])

xml_string = re.sub(
    '<query_execution_time_in_seconds>0.\\d+</query_execution_time_in_seconds>',
    '<query_execution_time_in_seconds>0</query_execution_time_in_seconds>',
    xml_string)
xml_string = re.sub(
    '<time_stamp>[\\d\\-: .]+</time_stamp>',
    '<time_stamp>0</time_stamp>',
    xml_string)

if __name__ == '__main__':
    with open(sys.argv[3], 'w') as f:
        f.write(xml_string)
