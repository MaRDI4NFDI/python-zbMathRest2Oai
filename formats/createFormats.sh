#!/bin/bash
#Create OAI_DC Format
AUTH=$(echo -n "$OAI_BASIC_USER:$OAI_BASIC_PASSWORD" | base64)
#printf "\n\nCreate Format oai_dc\n\n"
#curl --noproxy '*' -X POST -H 'Content-Type: application/json' -H  "Authorization: Basic $AUTH"  -i 'https://oai-input.portal.mardi4nfdi.de/oai-backend/format' --data '{"metadataPrefix":"oai_dc","schemaLocation":"http://www.openarchives.org/OAI/2.0/oai_dc.xsd","schemaNamespace":"http://www.openarchives.org/OAI/2.0/oai_dc/","identifierXpath":"/identifier"}'

#printf "\n\nCreate Format datacite\n\n"
#curl --noproxy '*' -X POST -H 'Content-Type: application/json' -H  "Authorization: Basic $AUTH" -i 'https://oai-input.portal.mardi4nfdi.de/oai-backend/format' --data '{"metadataPrefix":"datacite","schemaLocation":"https://schema.datacite.org/meta/kernel-4.0/metadata.xsd","schemaNamespace":"http://datacite.org/schema/kernel-4","identifierXpath":""}'

printf "\n\nCreate Format zbmath_rest_api_software\n\n"
curl --noproxy '*' -X PUT -H 'Content-Type: application/json' -H  "Authorization: Basic $AUTH" -i 'https://oai-input.portal.mardi4nfdi.de/oai-backend/format' --data '{"metadataPrefix":"zbmath_rest_api_software2","schemaLocation":"https://github.com/MaRDI4NFDI/python-zbMathRest2Oai/blob/main/test/data/software/plain.xml","schemaNamespace":"https://github.com/MaRDI4NFDI/python-zbMathRest2Oai/blob/main/tests/data/software/","identifierXpath":"/identifier"}'


printf "\n\nCreate Format datacite_swmath\n\n"
curl --noproxy '*' -X PUT -H 'Content-Type: application/json' -H  "Authorization: Basic $AUTH" -i 'https://oai-input.portal.mardi4nfdi.de/oai-backend/format' --data '{"metadataPrefix":"datacite_swmath","schemaLocation":"https://raw.githubusercontent.com/MaRDI4NFDI/python-zbMathRest2Oai/main/test/data/software/swmath2datacite_software_schema.xsd","schemaNamespace":"http://datacite.org/schema/kernel-4","identifierXpath":"/identifier"}'


#printf "\n\nCreate Format datacite\n\n"
#curl --noproxy '*' -X POST -H 'Content-Type: application/json' -H  "Authorization: Basic $AUTH" -i 'https://oai-input.portal.mardi4nfdi.de/oai-backend/format' --data '{"metadataPrefix":"oai_zb_preview","schemaLocation":"https://zbmath.org/OAI/2.0/oai_zb_preview/","schemaNamespace":"https://zbmath.org/zbmath/elements/1.0/","identifierXpath":""}'

#printf "\n\n Read all formats\n\n"

curl --noproxy '*' -X GET -H  "Authorization: Basic $AUTH"  'https://oai-input.portal.mardi4nfdi.de/oai-backend/format'