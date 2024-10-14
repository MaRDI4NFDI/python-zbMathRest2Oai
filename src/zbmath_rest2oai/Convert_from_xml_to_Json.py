import xmltodict
import json
import os




def XmlToJson(xml_file , json_file):

 print("Current working directory:", os.getcwd())

xml_result = "../../test/data/software/Test_Result_Codemeta.xml"

with open(xml_result) as xml_file:
    data_dict = xmltodict.parse(xml_file.read())

    json_data = json.dumps(data_dict , indent=2, ensure_ascii=False)

with open("../../test/data/software/test_Result_Codemeta.json", "w") as json_file:
     json_file.write(json_data)

