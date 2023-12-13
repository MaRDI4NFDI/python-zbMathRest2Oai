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
                if parent_name.endswith('s'):
                    parent_name = parent_name[:-1]

                if xml._get_lastChild().nodeName == parent_name:
                    xml = append_text_child(xmld, xml, parent_name, obj[i])
                else:
                    xml = append_text_child(xmld, xml._get_lastChild(), parent_name, obj[i])
            elif type(obj[i]) in all_iter_list:
                func_get_doc_to_xml(obj[i], xml)
            else:
                print("WARNING")
                print(obj[i])


    if type(obj) == dict:
        for key in obj.keys():
            if obj[key]==[]:
                xml = append_text_child(xmld, xml, key, 'missing')
            elif obj[key] is None:
                xml = append_text_child(xmld, xml, key, 'missing')
            elif type(obj[key]) in [str,int]:
                xml = append_text_child(xmld, xml, key, obj[key])
            elif type(obj[key]) in all_iter_list:
                xml = append_text_child(xmld, xml, key, "")
                func_get_doc_to_xml(obj[key], xml)
    return xml

final_xml = func_get_doc_to_xml(res.result, ron)

print(final_xml.toprettyxml())


