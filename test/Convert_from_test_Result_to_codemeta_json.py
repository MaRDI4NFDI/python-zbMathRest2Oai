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
        "author": []
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
