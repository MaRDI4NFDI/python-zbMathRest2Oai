import defusedxml.ElementTree as DET  # Using defusedxml for safe XML parsing
from defusedxml.lxml import fromstring
from zbmath_rest2oai import getAsXml
import lxml.etree as ET

prefix_final_xml2='oai:zbmath.org:'
api_source='https://api.zbmath.org/v1/document/_all?start_after=0&results_per_request=500'
out= getAsXml.final_xml2(api_source, prefix_final_xml2)

def contains_doi(xml_str):
    # Parse the XML string
    root = DET.fromstring(xml_str)

    # Use XPath to find a <links> element with a <type> child that has text "doi"
    doi_link = root.find(".//links[type='doi']")
    return doi_link is not None

xsl_filename = 'xslt/articles/xslt-article-Datacite.xslt'
xslt = ET.parse(xsl_filename)
transform = ET.XSLT(xslt)

for id in out[0].keys():
    if contains_doi(out[0][id]):
        dom = DET.fromstring(out[0][id])
        dom_str = DET.tostring(dom, encoding='unicode')
        lxml_dom = fromstring(dom_str)
        newdom = transform(lxml_dom)
        formatted_newdom = ET.tostring(newdom, pretty_print=True, encoding='unicode')
        with open("src/local_export/extract_for_datacite/%s.xml" % id.replace(":","_").replace(".","_"), "w") as f:
            f.write(formatted_newdom)
            f.close()