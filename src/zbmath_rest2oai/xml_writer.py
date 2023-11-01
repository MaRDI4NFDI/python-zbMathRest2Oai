from xml.dom import minidom  # Create XML document

from swagger_client import AllOfzbmathApiDataModelsDisplayDocumentsResultIDResult as Doc


def create_document(doc: Doc):
    xmld = minidom.Document()
    root = xmld.createElement("root")
    root.appendChild(xmld.createTextNode(str(doc.id)))
    xmld.appendChild(root)
    return xmld
