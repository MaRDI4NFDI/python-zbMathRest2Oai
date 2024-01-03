import swagger_client
import json
from zbmath_rest2oai.xml_writer import create_document

import json
import re
with open('C:/Users/maz/PycharmProjects/myenv-zbmathopen/python-zbMathRest2Oai/src/zbmath_rest2oai/output mapping - Copy.json') as f:
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

            if xml.lastChild.nodeName in ["zbmath:author_ids","zbmath:author_id", "zbmath:review","zbmath:keywords","zbmath:keyword"]:
                parent_name = xml.lastChild.nodeName
            else:
                parent_name = xml.nodeName

            #str_no_zbmath_parent_name = re.sub("zbmath:", "", parent_name)



            #if str_no_zbmath_parent_name in d.keys():
                #parent_name = parent_name.replace(str_no_zbmath_parent_name, d[str_no_zbmath_parent_name][0])
            #if obj[i] == [] or obj[i] is None:
                #print(xml.nodeName)
                #xml = append_text_child(xmld, xml, parent_name, 'missing')

            if type(obj[i]) in [str,int]:
                if parent_name in ['zbmath:ref_id', 'zbmath:_doi', 'zbmath:text']:

                    #if xml.getElementsByTagName('zbmath:reference') != []:

                    #xml = append_text_child(xmld, xml.getElementsByTagName('zbmath:reference')[-1], parent_name, obj[i])
                    xml = append_text_child(xmld, xml, parent_name, obj[i])


                elif parent_name in ["zbmath:author_ids","zbmath:author_id", "zbmath:keywords", "zbmath:keyword", 'zbmath:ref_classifications']:
                    if parent_name.endswith('s'):
                        parent_name = parent_name[:-1]

                    if parent_name in ["zbmath:keyword", "zbmath:author_id"]:
                        if xml.nodeName in ["zbmath:keywords","zbmath:author_ids"]:
                            xml = append_text_child(xmld, xml, parent_name, obj[i])
                        if xml.nodeName == "oai_zb_preview:zbmath":
                            xml = append_text_child(xmld, xml.getElementsByTagName(xml.lastChild.nodeName)[0], parent_name, obj[i])
                    else:
                        xml = append_text_child(xmld, xml, parent_name, obj[i])

                else:
                    #print(parent_name, obj[i], xml.lastChild.nodeName)
                    print(0)

            elif type(obj[i]) in all_iter_list:
                func_get_doc_to_xml(obj[i], xml)


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

                if type(new_obj[key]) in [str,int, [], None]:
                    if key in ['ref_classifications', 'ref_id', '_doi', '_text', 'text','#text']:

                        if xml.nodeName == 'zbmath:references':
                            xml = xml.lastChild
                            l = [node.nodeName.replace("zbmath:", "") for node in xml.childNodes]
                            if '_text' in l or 'text' in l or '#text' in l:
                                xml = xml.parentNode
                                xml = append_text_child(xmld, xml, 'reference', "")
                                xml = xml.lastChild

                        if xml.nodeName == 'zbmath:_author_codes':
                            xml = xml.parentNode
                            l = [node.nodeName.replace("zbmath:", "") for node in xml.childNodes]
                            if '_text' in l or 'text' in l or '#text' in l:
                                xml = xml.parentNode
                                xml = append_text_child(xmld, xml, 'reference', "")
                                xml = xml.lastChild

                        xml = append_text_child(xmld, xml, key, new_obj[key])


                    elif type(new_obj[key]) in [[], None]:
                        xml = append_text_child(xmld, xml, key, 'missing')
                    else:

                        if xml.nodeName == 'zbmath:references':
                            b = xml.getElementsByTagName('zbmath:reference')
                            b = [s for s in b if not b == '']
                            xml = append_text_child(xmld, b[-1], key, new_obj[key])
                        elif xml.nodeName == 'zbmath:reference':

                            xml = append_text_child(xmld, xml, key, new_obj[key])
                        else:
                            xml = append_text_child(xmld, xml, key, new_obj[key])


                elif type(new_obj[key]) in all_iter_list:
                    if type(new_obj[key]) not in [list,dict]:
                        new_obj[key] = new_obj[key].__dict__

                    if type(new_obj[key]) ==dict:

                        l_values = [node.nodeName for node in xml.childNodes]
                        l_values.sort()

                        if len(list(set(l_values))) < len(l_values):
                            if xml.nodeName=="zbmath:reference":
                                xml = xml.parentNode
                                xml = append_text_child(xmld, xml, 'reference', "")
                            elif xml.nodeName=="zbmath:references":
                                xml = append_text_child(xmld, xml, 'reference', "")
                            else:
                                print(xml.nodeName)
                        elif xml.lastChild is not None:
                            if xml.lastChild.nodeName == "zbmath:review":
                                xml = append_text_child(xmld, xml.lastChild, key, "")

                            if xml.lastChild.nodeName == "zbmath:reference":
                                xml = append_text_child(xmld, xml.lastChild, key, "")
                        else:

                            xml = append_text_child(xmld, xml, key, "")

                    if type(new_obj[key]) == list:
                        if key == 'references':
                            xml = append_text_child(xmld, xml, 'references', "")
                            xml = append_text_child(xmld, xml.lastChild, 'reference', "")



                        elif xml.nodeName == 'zbmath:reference' and key != 'ref_classifications':
                            print("HERE1" + key)
                            a = xml.childNodes
                            h = [node.nodeName for node in a]
                            if 'zbmath:'+key in h:
                                xml = xml.parentNode
                                xml = append_text_child(xmld, xml, 'reference', "")
                                xml = append_text_child(xmld, xml.lastChild, key, "")
                                xml = xml.lastChild

                        elif key == 'ref_classifications':
                            print("HERE2" + key)

                            if xml.nodeName == "oai_zb_preview:zbmath":
                                xml = append_text_child(xmld, xml, key, "")

                            if xml.nodeName== "zbmath:_author_codes":
                                xml= xml.parentNode

                            if xml.nodeName == "zbmath:reference":
                                xml = append_text_child(xmld, xml, key, "")
                                xml = xml.lastChild


                        elif key == "_author_codes":

                            if xml.nodeName == "oai_zb_preview:zbmath":
                                xml = append_text_child(xmld, xml, key, "")
                            if xml.nodeName == "zbmath:references":
                                xml = append_text_child(xmld, xml.lastChild, key, "")

                        else:
                            xml = append_text_child(xmld, xml, key, "")

                func_get_doc_to_xml(new_obj[key], xml)
    return xml

final_xml = func_get_doc_to_xml(res.result, ron)


l= final_xml.childNodes

#print([node.nodeName for node in l])
#print(final_xml.getElementsByTagName('zbmath:references'))
####

## STRATEGY TO SOLVE the situation with inner indentation. IF elem in Happening node, append child and recurs func ELSE, happend node normally
##
#list_nodes_remove = []
#for i in range(len(l)):
#    if l[i].localName in ['_contributors','_authors', '_aliases', '_checked', '_author_references', '_reviewer', '_editors', '_author_codes']:
#        list_nodes_remove.append(l[i])

#for node in list_nodes_remove:
#    final_xml.removeChild(node)

print(final_xml.parentNode.parentNode.toprettyxml())




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


