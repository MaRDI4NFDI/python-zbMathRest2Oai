from xml.dom import minidom  # Create XML document


def create_document(json: dict):
    xmld = minidom.Document()
    root = xmld.createElement("root")
    root.appendChild(xmld.createTextNode( str ( json.get('result').get('id')) ))
    xmld.appendChild(root)
    return xmld
