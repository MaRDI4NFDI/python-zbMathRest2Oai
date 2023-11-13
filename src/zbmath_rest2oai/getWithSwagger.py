import swagger_client

from zbmath_rest2oai.xml_writer import create_document

api_instance = swagger_client.DocumentApi(swagger_client.ApiClient())
res = api_instance.get_document_by_zbmath_id_document_id_get(id="6383667")
doc = res.result
xmld = create_document(doc)


ron = xmld.createElement("oai_zb_preview:zbmath")
ron.setAttributeNS(
    "xmls",
    "xmlns:oai_zb_preview",
    "https://zbmath.org/OAI/2.0/oai_zb_preview/",
)
ron.setAttributeNS(
    "xmls",
    "xmlns:zbmath",
    "https://zbmath.org/zbmath/elements/1.0/",
)
ron.setAttributeNS(
    "xmls",
    "xmlns:xsi",
    "http://www.w3.org/2001/XMLSchema-instance",
)


def append_text_child(xmld, parent, name, value):
    """
    Creates new text node and appends it to parent
    :param xmld:
    :param parent: the node to append to
    :param name:
    :param value:
    """
    x_elem = xmld.createElement(f"zbmath:{name}")
    text = xmld.createTextNode(str(value))
    x_elem.appendChild(text)
    parent.appendChild(x_elem)
    return parent


final_xml = append_text_child(xmld, ron, "id", res.result.id)
#print(final_xml)

def func_json_keys(json_part, l):
    
    try:
        print('test0')
        json_part.__dict__
            #if type(json_part)==dict:
        index = json_part.__dict__.keys()
    except:
        print('test1')
        index = json_part
        for elem in index:
            if type(json_part[elem].__dict__)==dict or type(json_part[elem])==list:
                func_json_keys(json_part[elem], l)
            else:
                l.append([elem, json_part[elem]])

    return l

l0=[]
infos_list = func_json_keys(dict(res.__dict__), l0)
print(infos_list)
for j in infos_list:
    final_xml = append_text_child(xmld, final_xml, j[0], j[1])

#print(final_xml.toprettyxml())
