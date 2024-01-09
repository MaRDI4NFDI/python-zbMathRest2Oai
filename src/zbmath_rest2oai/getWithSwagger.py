import os.path

import swagger_client
from zbmath_rest2oai.xml_writer import create_document

import json

with open(os.path.join(os.path.dirname(__file__), './output mapping - Copy.json')) as f:
    d = json.load(f)


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


def func_get_doc_to_xml(obj, xml, root_doc):
    swagger_client_dicttype_list = [
        swagger_client.models.all_ofzbmath_api_data_models_display_documents_result_id_result.AllOfzbmathApiDataModelsDisplayDocumentsResultIDResult,
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

    nodes_names_not_to_add = ['_position', '_series_id', '_prefix', '_number', '_type', '_states', 'discriminator',
                              '_biographic_references', '_data_source', '_checked']
    if type(obj) in swagger_client_dicttype_list:
        obj = obj.__dict__

    if type(obj) is list:
        for i in range(len(obj)):

            if xml.lastChild and  xml.lastChild.nodeName in ["zbmath:author_ids", "zbmath:author_id", "zbmath:review", "zbmath:keywords",
                                          "zbmath:keyword"]:
                parent_name = xml.lastChild.nodeName
            else:
                parent_name = xml.nodeName

            if type(obj[i]) in [str, int]:
                if parent_name in ['zbmath:ref_id', 'zbmath:_doi', 'zbmath:text']:
                    xml = append_text_child(root_doc, xml, parent_name, obj[i])

                elif parent_name in ["zbmath:author_ids", "zbmath:author_id", "zbmath:keywords", "zbmath:keyword",
                                     'zbmath:ref_classifications']:
                    if parent_name.endswith('s'):
                        parent_name = parent_name[:-1]

                    if parent_name in ["zbmath:keyword", "zbmath:author_id"]:
                        if xml.nodeName in ["zbmath:keywords", "zbmath:author_ids"]:
                            xml = append_text_child(root_doc, xml, parent_name, obj[i])
                        if xml.nodeName == "oai_zb_preview:zbmath":
                            xml = append_text_child(root_doc, xml.getElementsByTagName(xml.lastChild.nodeName)[0],
                                                    parent_name, obj[i])
                    else:
                        xml = append_text_child(root_doc, xml, parent_name, obj[i])

            elif type(obj[i]) in all_iter_list:
                func_get_doc_to_xml(obj[i], xml, root_doc)

    if type(obj) is dict:
        new_obj = {}
        for key_init in obj.keys():
            if key_init in d.keys():
                if key_init == '_code':
                    if xml.lastChild.nodeName == 'zbmath:ref_classifications':
                        new_obj[d[key_init][1]] = obj[key_init]
                    else:
                        new_obj[d[key_init][0]] = obj[key_init]
                else:
                    new_obj[d[key_init][0]] = obj[key_init]
            else:
                new_obj[key_init] = obj[key_init]

        for key in new_obj.keys():
            if key not in nodes_names_not_to_add:

                if type(new_obj[key]) in [str, int, [], None]:
                    if key in ['ref_classifications', 'ref_id', '_doi', '_text', 'text', '#text']:

                        if xml.nodeName == 'zbmath:references':
                            xml = xml.lastChild
                            l = [node.nodeName.replace("zbmath:", "") for node in xml.childNodes]
                            if '_text' in l or 'text' in l or '#text' in l:
                                xml = xml.parentNode
                                xml = append_text_child(root_doc, xml, 'reference', "")
                                xml = xml.lastChild

                        if xml.nodeName == 'zbmath:_author_codes':
                            xml = xml.parentNode
                            l = [node.nodeName.replace("zbmath:", "") for node in xml.childNodes]
                            if '_text' in l or 'text' in l or '#text' in l:
                                xml = xml.parentNode
                                xml = append_text_child(root_doc, xml, 'reference', "")
                                xml = xml.lastChild

                        xml = append_text_child(root_doc, xml, key, new_obj[key])

                    elif type(new_obj[key]) in [[], None]:
                        xml = append_text_child(root_doc, xml, key, 'missing')
                    else:

                        if xml.nodeName == 'zbmath:references':
                            b = xml.getElementsByTagName('zbmath:reference')
                            b = [s for s in b if not b == '']
                            xml = append_text_child(root_doc, b[-1], key, new_obj[key])
                        elif xml.nodeName == 'zbmath:reference':

                            xml = append_text_child(root_doc, xml, key, new_obj[key])
                        else:
                            xml = append_text_child(root_doc, xml, key, new_obj[key])

                elif type(new_obj[key]) in all_iter_list:
                    if type(new_obj[key]) not in [list, dict]:
                        new_obj[key] = new_obj[key].__dict__

                    if type(new_obj[key]) is dict:

                        l_values = [node.nodeName for node in xml.childNodes]
                        l_values.sort()

                        if len(list(set(l_values))) < len(l_values):
                            if xml.nodeName == "zbmath:reference":
                                xml = xml.parentNode
                                xml = append_text_child(root_doc, xml, 'reference', "")
                            elif xml.nodeName == "zbmath:references":
                                xml = append_text_child(root_doc, xml, 'reference', "")
                            else:
                                print(xml.nodeName)
                        elif xml.lastChild is not None:
                            if xml.lastChild.nodeName == "zbmath:review":
                                xml = append_text_child(root_doc, xml.lastChild, key, "")

                            if xml.lastChild.nodeName == "zbmath:reference":
                                xml = append_text_child(root_doc, xml.lastChild, key, "")
                        # else:
                            # why add this
                            # xml = append_text_child(root_doc, xml, key, "")

                    if type(new_obj[key]) is list:
                        if key == 'references':
                            xml = append_text_child(root_doc, xml, 'references', "")
                            xml = append_text_child(root_doc, xml.lastChild, 'reference', "")

                        elif xml.nodeName == 'zbmath:reference' and key != 'ref_classifications':
                            a = xml.childNodes
                            h = [node.nodeName for node in a]
                            if 'zbmath:' + key in h:
                                xml = xml.parentNode
                                xml = append_text_child(root_doc, xml, 'reference', "")
                                xml = append_text_child(root_doc, xml.lastChild, key, "")
                                xml = xml.lastChild

                        elif key == 'ref_classifications':
                            if xml.nodeName == "oai_zb_preview:zbmath":
                                xml = append_text_child(root_doc, xml, key, "")

                            if xml.nodeName == "zbmath:_author_codes":
                                xml = xml.parentNode

                            if xml.nodeName == "zbmath:reference":
                                xml = append_text_child(root_doc, xml, key, "")
                                xml = xml.lastChild

                        elif key == "_author_codes":

                            if xml.nodeName == "oai_zb_preview:zbmath":
                                xml = append_text_child(root_doc, xml, key, "")
                            if xml.nodeName == "zbmath:references":
                                xml = append_text_child(root_doc, xml.lastChild, key, "")

                        elif not key.startswith("_"):
                             # this adds _elements, why do we need those
                             xml = append_text_child(root_doc, xml, key, "")

                func_get_doc_to_xml(new_obj[key], xml, root_doc)
    return xml


def append_zb_rights(xmld, ron):
    x_links = xmld.createElement("zbmath:rights")
    text = xmld.createTextNode(
        """Content generated by zbMATH Open, such as reviews,
            classifications, software, or author disambiguation data,
            are distributed under CC-BY-SA 4.0. This defines the license for the
            whole dataset, which also contains non-copyrighted bibliographic
            metadata and reference data derived from I4OC (CC0). Note that the API
            only provides a subset of the data in the zbMATH Open Web interface. In
            several cases, third-party information, such as abstracts, cannot be
            made available under a suitable license through the API. In those cases,
            we replaced the data with the string 'zbMATH Open Web Interface contents
            unavailable due to conflicting licenses.'
            """
    )
    x_links.appendChild(text)
    ron.appendChild(x_links)


def get_final_xml(de: str):
    api_instance = swagger_client.DocumentApi(swagger_client.ApiClient())
    res = api_instance.get_document_by_zbmath_id_document_id_get(id=de)
    doc = res.result
    root_doc = create_document(doc)

    ron = root_doc.createElement("oai_zb_preview:zbmath")
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
    xml = func_get_doc_to_xml(
        res.result,
        ron,
        root_doc
    )
    append_zb_rights(root_doc, ron)
    return xml


final_xml = get_final_xml("6383667")

print(final_xml.parentNode.parentNode.toprettyxml())
