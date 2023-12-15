import swagger_client
import json
from zbmath_rest2oai.xml_writer import create_document

import json
import re
with open('/home/maxence/myvenv/python-zbMathRest2Oai/src/zbmath_rest2oai/output mapping - Copy.json') as f:
    d = json.load(f)
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
    string_name = name
    if "zbmath:" not in name:
        string_name = f"zbmath:{name}"
    x_elem = xmld.createElement(string_name)
    text = xmld.createTextNode(str(value))
    x_elem.appendChild(text)
    parent.appendChild(x_elem)
    return parent


def func_get_doc_to_xml(obj, xml):
    swagger_client_dicttype_list = [swagger_client.models.all_ofzbmath_api_data_models_display_documents_result_id_result.AllOfzbmathApiDataModelsDisplayDocumentsResultIDResult,
                                    swagger_client.models.all_of_document_contributors.AllOfDocumentContributors,
                                    swagger_client.models.zbmath_api_data_models_display_documents_submodels_author.ZbmathApiDataModelsDisplayDocumentsSubmodelsAuthor,
                                    swagger_client.models.editorial_contribution.EditorialContribution,
                                    swagger_client.models.all_of_editorial_contribution_reviewer.AllOfEditorialContributionReviewer,
                                    swagger_client.models.all_of_document_language.AllOfDocumentLanguage,
                                    swagger_client.models.link.Link,
                                    swagger_client.models.msc.MSC,
                                    swagger_client.models.reference.Reference,
                                    swagger_client.models.all_of_reference_zbmath.AllOfReferenceZbmath,
                                    swagger_client.models.all_of_document_source.AllOfDocumentSource,
                                    swagger_client.models.series.Series,
                                    swagger_client.models.all_of_document_title.AllOfDocumentTitle,
                                    swagger_client.models.zbmath_api_data_models_display_documents_submodels_issn.ZbmathApiDataModelsDisplayDocumentsSubmodelsISSN]

    all_iter_list = [list, dict]
    all_iter_list.extend(swagger_client_dicttype_list)

    nodes_names_not_to_add = ['_position','_series_id','_prefix','_number', '_type', '_states', 'discriminator', '_biographic_references', '_data_source']
    if type(obj) in swagger_client_dicttype_list:
        obj = obj.__dict__

    if type(obj) == list:
        for i in range(len(obj)):
            parent_name = xml.lastChild.nodeName
            str_no_zbmath_parent_name = re.sub("zbmath:", "", parent_name)

            if str_no_zbmath_parent_name in d.keys():
                parent_name = parent_name.replace(str_no_zbmath_parent_name, d[str_no_zbmath_parent_name][0])
            if obj[i]==[]:
                xml = append_text_child(xmld, xml, parent_name, 'missing')
            elif obj[i] is None:
                xml = append_text_child(xmld, xml, parent_name, 'missing')
            elif type(obj[i]) in [str,int]:
                if parent_name in ['zbmath:ref_classifications', 'zbmath:ref_id', 'zbmath:_doi', 'zbmath:text']:
                    if xml.getElementsByTagName('zbmath:_references') != []:
                        xml = append_text_child(xmld, xml.getElementsByTagName('zbmath:references')[-1], parent_name, obj[i])

                else:
                    #if parent_name.endswith('s'):
                    #   parent_name = parent_name[:-1]


                    if xml._get_lastChild().nodeName == parent_name :
                        xml = append_text_child(xmld, xml, parent_name, obj[i])

                    else:
                        xml = append_text_child(xmld, xml, parent_name, obj[i])


            elif type(obj[i]) in all_iter_list:
                func_get_doc_to_xml(obj[i], xml)
            else:
                print("WARNING")
                print(obj[i])


    if type(obj) == dict:
        new_obj = dict()
        for key_init in obj.keys():
            if key_init in d.keys():
                if key_init == '_code':
                    if xml.lastChild.nodeName=='zbmath:ref_classifications':
                        new_obj[d[key_init][1]] = obj[key_init]
                    else:
                        new_obj[d[key_init][0]] = obj[key_init]
                else:
                    new_obj[d[key_init][0]] = obj[key_init]
            else:
                new_obj[key_init] = obj[key_init]

        for key in new_obj.keys():
            if key not in nodes_names_not_to_add:
                if new_obj[key]==[]:
                    xml = append_text_child(xmld, xml, key, 'missing')
                elif new_obj[key] is None:
                    xml = append_text_child(xmld, xml, key, 'missing')
                elif type(new_obj[key]) in [str,int]:

                    if key in ['ref_classifications', 'ref_id', '_doi', 'text']:
                        b= xml.getElementsByTagName('zbmath:references')
                        b = [s for s in b if not b == '']
                        if len(b)!=0:
                            xml = append_text_child(xmld, b[-1], key, new_obj[key])
                    else:
                        print('HEEREEEEE')
                        print(key)
                        print(new_obj[key])
                        print(dir(xml))
                        xml = append_text_child(xmld, xml, key, new_obj[key])

                elif type(new_obj[key]) in all_iter_list:
                    xml = append_text_child(xmld, xml, key, "")
                    func_get_doc_to_xml(new_obj[key], xml)
            else:
                continue
    return xml

final_xml = func_get_doc_to_xml(res.result, ron)


l= final_xml.childNodes

####

## STRATEGY TO SOLVE the situation with inner indentation. IF elem in Happening node, append child and recurs func ELSE, happend node normally
##
list_nodes_remove = []
for i in range(len(l)):
    if l[i].localName in ['_contributors','_authors', '_aliases', '_checked', '_author_references', '_reviewer', '_editors','_editorial_contributions', '_author_codes']:
        list_nodes_remove.append(l[i])

for node in list_nodes_remove:
    final_xml.removeChild(node)

print(final_xml.toprettyxml())
#print(dir(final_xml))




### PART OF THE CODE TO SORT THE FINAL XML
ron1 = xmld.createElement("oai_zb_preview:zbmath")
ron1.setAttributeNS(
    "xmls",
    "xmlns:oai_zb_preview",
    "https://zbmath.org/OAI/2.0/oai_zb_preview/",
)
ron1.setAttributeNS(
    "xmls",
    "xmlns:zbmath",
    "https://zbmath.org/zbmath/elements/1.0/",
)
ron1.setAttributeNS(
    "xmls",
    "xmlns:xsi",
    "http://www.w3.org/2001/XMLSchema-instance",
)

#sorted_dict = dict(sorted(dict(zip([i.localName for i in l],l)).items()))
#for key in sorted_dict.keys():
#    ron1.appendChild(sorted_dict[key])

#print(ron1.toprettyxml())


