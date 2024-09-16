import json
import os

# Function to convert the input JSON format to the desired format
def convert_json(data):
    # Initialize the new format with the desired structure
    new_format = {
        "@context": "https://doi.org/10.5063/schema/codemeta-2.0",
        "@type": "SoftwareSourceCode",
        "identifier": data.get("entry", {}).get("codemeta:identifier", [None])[0],
        "description": data.get("entry", {}).get("codemeta:description"),
        "name": data.get("entry", {}).get("codemeta:name"),
        "url": data.get("entry", {}).get("codemeta:url"),
        "relatedLink": [
            data.get("entry", {}).get("swhdeposit:deposit", {}).get("swhdeposit:metadata-provenance", {}).get("schema:url"),
            data.get("entry", {}).get("codemeta:sameAs")
        ],
        "codeRepository": data.get("entry", {}).get("codemeta:codeRepository"),
        "license": None,
        "programmingLanguage": {
            "@type": "ComputerLanguage",
            "name": data.get("entry", {}).get("codemeta:programmingLanguage"),
            "url": data.get("entry", {}).get("codemeta:sameAs")
        },
        "runtimePlatform": "None",  # Additional field
        "provider": {  # Additional field
            "@type": "Organization",
            "name": "zbMATH Open Web Interface",
            "url": "https://zbmath.org"
        },
        "author": [],
        "keywords": data.get("entry", {}).get("codemeta:keywords", []),
        "contributor": None,
        "copyrightHolder": None,
        "funder": None,
        "maintainer": None,
        "isPartOf": None,
        "fileSize": None,
        "releaseNotes": None,
        "readme": None,
        "contentIntegration": None,
        "developmentStatus": None,
        "itemListElement": {
            "@type": "Integer",
            "numberOfItems": data.get("entry", {}).get("codemeta:itemList", "2775")
        }
    }

    # Extract and transform author information
    authors = data.get("entry", {}).get("codemeta:author", {}).get("codemeta:author", [])
    for author in authors:
        reshaped_author = {
            "@type": "Person",
            "givenName": author.get("codemeta:givenName"),
            "familyName": author.get("codemeta:familyName")
        }
        new_format["author"].append(reshaped_author)

        in_code_set = data.get("entry", {}).get("codemeta:inCodeSet", [])
        if in_code_set:
            category_code_set = {}
            for idx, code in enumerate(in_code_set, start=1):
                category_code_set[str(idx)] = {
                    "@type": "CategoryCode",
                    "descrption": "Mathematical Subject Classification",
                    "inCodeSet": code
                }
            new_format["CategoryCodeSet"] = category_code_set

    supporting_data = data.get("entry", {}).get("codemeta:supportingData", {})
    supporting_names = supporting_data.get("codemeta:name", [])
    supporting_identifiers = supporting_data.get("codemeta:identifier", [])

    if supporting_names and supporting_identifiers:
        # Ensure that the number of names and identifiers are the same
        supporting_list = []
        for name, identifier in zip(supporting_names, supporting_identifiers):
            supporting_item = {
                "@type": "DataFeed",
                "identifier": identifier,
                "name": name
            }
            supporting_list.append(supporting_item)

        new_format["supportingData"] = supporting_list

        citation = data.get("entry", {}).get("codemeta:citation", {})
        citation_identifiers = citation.get("codemeta:identifier", [])
        citation_sources = citation.get("codemeta:hasSource", [])
        citation_headlines = citation.get("codemeta:headline", [])
        citation_dates = citation.get("codemeta:datePublished", [])

        if citation_identifiers and citation_sources and citation_headlines and citation_dates:
            citation_list = []
            for identifier, source, headline, date in zip(citation_identifiers, citation_sources, citation_headlines,
                                                          citation_dates):
                citation_item = {
                    "@type": "publication",
                    "identifier": identifier,
                    "hasSource": source,
                    "headline": headline,
                    "datePublished": date
                }
                citation_list.append(citation_item)

            new_format["Citation"] = citation_list

    return new_format


# Path to the input JSON file
input_file_path = r'C:\Users\smm\PycharmProjects\python-zbMathRest2Oai\test\data\software\test_Result_Codemeta.json'
# Path to the output JSON file
output_file_path = 'data/software/converted_data_to_Codemeta.json'

# Ensure the input file exists
if not os.path.isfile(input_file_path):
    print(f"Error: The file {input_file_path} does not exist.")
    exit(1)

try:
    # Read the JSON data from the file
    with open(input_file_path, 'r', encoding='utf-8') as file:
        input_json = json.load(file)

    # Print the input JSON to verify it's read correctly
    print("Input JSON data:")
    print(json.dumps(input_json, indent=2, ensure_ascii=False))

    # Convert the JSON data
    converted_json = convert_json(input_json)

    # Print the converted JSON to verify the transformation
    print("Converted JSON data:")
    print(json.dumps(converted_json, indent=2, ensure_ascii=False))

    # Write the converted JSON data to a new file
    with open(output_file_path, 'w', encoding='utf-8') as file:
        json.dump(converted_json, file, indent=2, ensure_ascii=False)

    print(f"Converted data has been saved to {output_file_path}")

except json.JSONDecodeError as e:
    print(f"Error decoding JSON: {e}")
except Exception as e:
    print(f"An unexpected error occurred: {e}")
