import swagger_client
from zbmath_rest2oai.xml_writer import create_document

api_instance = swagger_client.DocumentApi(swagger_client.ApiClient())
res = api_instance.get_document_by_zbmath_id_document_id_get(id="6383667")
doc = res.result
print(create_document(doc).toprettyxml())
