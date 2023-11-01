import json

import requests

testXML = """
<resource xsi:schemaLocation="http://datacite.org/schema/kernel-4 http://schema.datacite.org/meta/kernel-4/metadata.xsd">
   <identifier identifierType="DOI">10.5072/38238</identifier>
   <creators>
      <creator>
         <creatorName>Admin, Admin</creatorName>
         <givenName>Admin</givenName>
         <familyName>Admin</familyName>
         <nameIdentifier schemeURI="http://orcid.org/" nameIdentifierScheme="ORCID">1231-1231-1111</nameIdentifier>
         <affiliation>FIZ Karlsruhe</affiliation>
      </creator>
   </creators>
   <titles>
      <title>Test zur Publikation 12072018</title>
      <title titleType="Subtitle">Dies ist der Untertitel</title>
   </titles>
   <publisher>FIZ Karlsruhe</publisher>
   <dates>
      <date dateType="Created">2018</date>
   </dates>
   <publicationYear>2018</publicationYear>
   <subjects>
      <subject>Verkehrskunde</subject>
      <subject>Verkehr, Schild, Warnung</subject>
   </subjects>
   <resourceType resourceTypeGeneral="Dataset"></resourceType>
   <rightsList>
      <rights>CC BY 4.0 Attribution</rights>
   </rightsList>
   <contributors>
      <contributor contributorType="RightsHolder">
         <contributorName>FIZ Karlsruhe</contributorName>
      </contributor>
      <contributor contributorType="DataCurator">
         <contributorName>Müller, Hansi</contributorName>
         <affiliation></affiliation>
      </contributor>
   </contributors>
   <descriptions>
      <description descriptionType="Abstract">In diesem Projekt geht es um die Untersuchung von fa-sfadsfdsfsddddddddddd</description>
      <description descriptionType="TechnicalInfo">Laxer XCV</description>
      <description descriptionType="Other">statistische Normierun</description>
      <description descriptionType="Other">Hier stehen...</description>
   </descriptions>
   <language>
          en
        </language>
   <alternateIdentifiers>
      <alternateIdentifier alternateIdentifierType="1234567489777">Interne Nummer</alternateIdentifier>
   </alternateIdentifiers>
   <relatedIdentifiers>
      <relatedIdentifier relatedIdentifierType="DOI" relationType="IsSupplementTo">10.1001/456456</relatedIdentifier>
   </relatedIdentifiers>
   <geoLocations>
      <geoLocation>
         <geoLocationPoint>
            <pointLongitude>49.0</pointLongitude>
            <pointLatitude>49.0</pointLatitude>
         </geoLocationPoint>
      </geoLocation>
   </geoLocations>
   <fundingReferences>
      <fundingReference>
         <funderName>Deutsche Forschungsgemeinschaft</funderName>
         <funderIdentifier funderIdentifierType="Crossref Funder ID">501100001659</funderIdentifier>
      </fundingReference>
   </fundingReferences>
   <sizes>
      <size></size>
   </sizes>
   <formats>
      <format>application/zip</format>
   </formats>
</resource>
"""

url = "https://www.w3schools.com/python/demopage.php"
files = {
    "item": (
        None,
        json.dumps(
            {
                "identifier": "10.5072/38238",
                "deleteFlag": False,
                "ingestFormat": "radar",
            }
        ),
        "application/json",
    ),
    "content": (None, testXML),
}
x = requests.delete('http://localhost:8081/oai-backend/item/10.5072%2F38238')
x = requests.post("http://localhost:8081/oai-backend/item", files=files)
x = requests.get('http://localhost:8081/oai-backend/item/10.5072%2F38238')

print(x.text)
