import json
import xml.etree.ElementTree as ET


def json_to_xml(json_data):
    # Create the root element
    root = ET.Element('root')

    # Add articles_count
    articles_count = ET.SubElement(root, 'articles_count')
    articles_count.text = str(json_data['result']['articles_count'])

    # Add authors
    for author in json_data['result']['authors']:
        author_elem = ET.SubElement(root, 'authors')
        author_elem.text = author

    # Add classification
    for classif in json_data['result']['classification']:
        classif_elem = ET.SubElement(root, 'classification')
        classif_elem.text = classif

    # Add swhdeposit:deposit section
    swhdeposit_elem = ET.SubElement(root, 'swhdeposit:deposit')
    swhdeposit_reference = ET.SubElement(swhdeposit_elem, 'swhdeposit:reference')
    swhdeposit_object = ET.SubElement(swhdeposit_reference, 'swhdeposit:object')
    swhdeposit_object.set('swhid',
                          json_data['swhdeposit:deposit']['swhdeposit:reference']['swhdeposit:object']['@swhid'])

    metadata_provenance = ET.SubElement(swhdeposit_elem, 'swhdeposit:metadata-provenance')
    schema_url = ET.SubElement(metadata_provenance, 'schema:url')
    schema_url.text = json_data['swhdeposit:deposit']['swhdeposit:metadata-provenance']['schema:url']

    # Add dependencies
    dependencies = ET.SubElement(root, 'dependencies')
    dependencies.text = str(json_data['result']['dependencies'])

    # Add description
    description = ET.SubElement(root, 'description')
    description.text = json_data['result']['description']

    # Add homepage
    homepage = ET.SubElement(root, 'homepage')
    homepage.text = json_data['result']['homepage']

    # Add id
    id_elem = ET.SubElement(root, 'id')
    id_elem.text = str(json_data['result']['id'])

    # Add keywords
    for keyword in json_data['result']['keywords']:
        keyword_elem = ET.SubElement(root, 'keywords')
        keyword_elem.text = keyword

    # Add license_terms
    license_terms = ET.SubElement(root, 'license_terms')
    license_terms.text = str(json_data['result']['license_terms'])

    # Add name
    name = ET.SubElement(root, 'name')
    name.text = json_data['result']['name']

    # Add operating_systems
    operating_systems = ET.SubElement(root, 'operating_systems')
    operating_systems.text = str(json_data['result']['operating_systems'])

    # Add orms_id
    orms_id = ET.SubElement(root, 'orms_id')
    orms_id.text = str(json_data['result']['orms_id'])

    # Add programming_languages
    programming_languages = ET.SubElement(root, 'programming_languages')
    programming_languages.text = str(json_data['result']['programming_languages'])

    # Add related_software
    for software in json_data['result']['related_software']:
        related_software_elem = ET.SubElement(root, 'related_software')
        software_id = ET.SubElement(related_software_elem, 'id')
        software_id.text = str(software['id'])
        software_name = ET.SubElement(related_software_elem, 'name')
        software_name.text = software['name']

    # Add source_code
    source_code = ET.SubElement(root, 'source_code')
    source_code.text = json_data['result']['source_code']

    # Add standard_articles
    for article in json_data['result']['standard_articles']:
        article_elem = ET.SubElement(root, 'standard_articles')
        article_authors = ET.SubElement(article_elem, 'authors')
        article_id = ET.SubElement(article_elem, 'id')
        article_id.text = str(article['id'])
        article_source = ET.SubElement(article_elem, 'source')
        article_source.text = article['source']
        article_title = ET.SubElement(article_elem, 'title')
        article_title.text = article['title']
        article_year = ET.SubElement(article_elem, 'year')
        article_year.text = article['year']

    # Add zbmath_url
    zbmath_url = ET.SubElement(root, 'zbmath_url')
    zbmath_url.text = json_data['result']['zbmath_url']

    return root

def indent_xml(elem, level=0):
    """Function to add indentation to XML."""
    i = "\n" + level * "  "
    if len(elem):
        if not elem.text or not elem.text.strip():
            elem.text = i + "  "
        if not elem.tail or not elem.tail.strip():
            elem.tail = i
        for sub_elem in elem:
            indent_xml(sub_elem, level + 1)
        if not sub_elem.tail or not sub_elem.tail.strip():
            sub_elem.tail = i
    else:
        if level and (not elem.tail or not elem.tail.strip()):
            elem.tail = i


def convert_json_to_xml(json_file_path, xml_output_path):
    # Load JSON from the given file path
    with open(json_file_path, 'r') as json_file:
        json_data = json.load(json_file)

    # Convert JSON to XML ElementTree
    root_element = json_to_xml(json_data)

    # Indent the XML properly
    indent_xml(root_element)

    # Create an ElementTree from the root element
    tree = ET.ElementTree(root_element)

    # Write the XML to a file with declaration and UTF-8 encoding
    tree.write(xml_output_path, encoding='utf-8', xml_declaration=True)

    print(f"XML data has been saved to {xml_output_path}")


# Example usage
json_file_path = '../../test/data/software/software_with_swhid.json'  # Update with your file path
xml_output_path = '../../test/data/software/software_with_swhid.xml'  # Update with your desired output path

convert_json_to_xml(json_file_path, xml_output_path)


