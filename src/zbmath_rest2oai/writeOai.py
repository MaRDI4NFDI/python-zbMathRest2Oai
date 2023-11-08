import json

import requests

testXML = """<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<ns2:radarDataset xmlns="http://radar-service.eu/schemas/descriptive/radar/v09/radar-elements" xmlns:ns2="http://radar-service.eu/schemas/descriptive/radar/v09/radar-dataset">
    <identifier identifierType="DOI">10.5072/38236</identifier>
    <alternateIdentifiers>
        <alternateIdentifier alternateIdentifierType="1234567489777">Interne Nummer</alternateIdentifier>
    </alternateIdentifiers>
    <relatedIdentifiers>
        <relatedIdentifier relatedIdentifierType="DOI" relationType="IsSupplementTo">10.1001/456456</relatedIdentifier>
    </relatedIdentifiers>
    <creators>
        <creator>
            <creatorName>Admin, Admin</creatorName>
            <givenName>Admin</givenName>
            <familyName>Admin</familyName>
            <nameIdentifier schemeURI="http://orcid.org/" nameIdentifierScheme="ORCID">1231-1231-1111</nameIdentifier>
            <creatorAffiliation>FIZ Karlsruhe</creatorAffiliation>
        </creator>
    </creators>
    <contributors>
        <contributor contributorType="DataCurator">
            <contributorName>Müller, Hansi</contributorName>
            <givenName>Hansi</givenName>
            <familyName>Müller</familyName>
        </contributor>
    </contributors>
    <title>Test zur Publikation 12072018</title>
    <additionalTitles>
        <additionalTitle additionalTitleType="Subtitle">Dies ist der Untertitel</additionalTitle>
    </additionalTitles>
    <descriptions>
        <description descriptionType="Abstract">In diesem Projekt geht es um die Untersuchung von fa-sfadsfdsfsddddddddddd</description>
    </descriptions>
    <keywords>
        <keyword>Verkehr, Schild, Warnung</keyword>
    </keywords>
    <publishers>
        <publisher>FIZ Karlsruhe</publisher>
    </publishers>
    <productionYear>2018</productionYear>
    <publicationYear>2018</publicationYear>
    <language>eng</language>
    <subjectAreas>
        <subjectArea>
            <controlledSubjectAreaName>Other</controlledSubjectAreaName>
            <additionalSubjectAreaName>Verkehrskunde</additionalSubjectAreaName>
        </subjectArea>
    </subjectAreas>
    <resource resourceType="Dataset"></resource>
    <geoLocations>
        <geoLocation>
            <geoLocationPoint>
                <latitude>49.0</latitude>
                <longitude>49.0</longitude>
            </geoLocationPoint>
        </geoLocation>
    </geoLocations>
    <dataSources>
        <dataSource dataSourceDetail="Instrument">Laxer XCV</dataSource>
    </dataSources>
    <software>
        <softwareType type="Resource Production">
            <softwareName softwareVersion="1.01.010111">Excel</softwareName>
            <alternativeSoftwareName alternativeSoftwareVersion="10.10.10">Tabellenfix</alternativeSoftwareName>
        </softwareType>
    </software>
    <processing>
        <dataProcessing>statistische Normierun</dataProcessing>
    </processing>
    <rights>
        <controlledRights>CC BY 4.0 Attribution</controlledRights>
    </rights>
    <rightsHolders>
        <rightsHolder>FIZ Karlsruhe</rightsHolder>
    </rightsHolders>
    <relatedInformations>
        <relatedInformation relatedInformationType="Zugehörige Informationne">Hier stehen...</relatedInformation>
    </relatedInformations>
    <fundingReferences>
        <fundingReference>
            <funderName>Deutsche Forschungsgemeinschaft</funderName>
            <funderIdentifier type="CrossRefFunder">501100001659</funderIdentifier>
        </fundingReference>
    </fundingReferences>
</ns2:radarDataset>
"""

url = "https://www.w3schools.com/python/demopage.php"
files = {
    "item": (
        None,
        json.dumps(
            {
                "identifier": "10.5072/38236",
                "deleteFlag": False,
                "ingestFormat": "radar",
            }
        ),
        "application/json",
    ),
    "content": (None, testXML),
}
# x = requests.delete('http://localhost:8081/oai-backend/item/10.5072%2F38238')
x = requests.post("http://localhost:8081/oai-backend/item", files=files)
print(x.text)

# x = requests.get('http://localhost:8081/oai-backend/item/10.5072%2F38236')

