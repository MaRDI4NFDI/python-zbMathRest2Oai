#!/bin/bash
OAI_BASIC_USER=swmath
AUTH=$(echo -n "$OAI_BASIC_USER:$OAI_BASIC_PASSWORD" | base64)

printf "\n\nCreate Format oai_dc\n\n"
curl --noproxy '*' -X POST -H 'Content-Type: application/json' -H  "Authorization: Basic $AUTH"  -i 'https://oai-input.portal.mardi4nfdi.de/oai-backend/format' --data '{"metadataPrefix":"oai_dc","schemaLocation":"http://www.openarchives.org/OAI/2.0/oai_dc.xsd","schemaNamespace":"http://www.openarchives.org/OAI/2.0/oai_dc/","identifierXpath":"/identifier"}'

printf "\n\nCreate Format datacite\n\n"
curl --noproxy '*' -X POST -H 'Content-Type: application/json' -H  "Authorization: Basic $AUTH" -i 'https://oai-input.portal.mardi4nfdi.de/oai-backend/format' --data '{"metadataPrefix":"datacite","schemaLocation":"https://schema.datacite.org/meta/kernel-4.0/metadata.xsd","schemaNamespace":"http://datacite.org/schema/kernel-4","identifierXpath":""}'

printf "\n\nCreate Format zbmath_rest_api\n\n"
curl --noproxy '*' -X POST -H 'Content-Type: application/json' -H  "Authorization: Basic $AUTH" -i 'https://oai-input.portal.mardi4nfdi.de/oai-backend/format' --data '{"metadataPrefix":"zbmath_rest_api","schemaLocation":"https://arxiv.org/abs/2106.04664","schemaNamespace":"https://api.zbmath.org/v1/document/","identifierXpath":"/root/id"}'

printf "\n\nCreate Format zbmath_rest_api_software\n\n"
curl --noproxy '*' -X POST -H 'Content-Type: application/json' -H  "Authorization: Basic $AUTH" -i 'https://oai-input.portal.mardi4nfdi.de/oai-backend/format' --data '{"metadataPrefix":"zbmath_rest_api_software","schemaLocation":"https://github.com/MaRDI4NFDI/python-zbMathRest2Oai/blob/main/test/data/software/plain.xml","schemaNamespace":"https://github.com/MaRDI4NFDI/python-zbMathRest2Oai/blob/main/tests/data/software/","identifierXpath":"/identifier"}'

printf "\n\nCreate Format datacite_swmath\n\n"
curl --noproxy '*' -X POST -H 'Content-Type: application/json' -H  "Authorization: Basic $AUTH" -i 'https://oai-input.portal.mardi4nfdi.de/oai-backend/format' --data '{"metadataPrefix":"datacite_swmath","schemaLocation":"https://raw.githubusercontent.com/MaRDI4NFDI/python-zbMathRest2Oai/main/test/data/software/swmath2datacite_software_schema.xsd","schemaNamespace":"http://datacite.org/schema/kernel-4","identifierXpath":"/identifier"}'

printf "\n\nCreate Format openaire_swmath\n\n"
curl --noproxy '*' -X POST -H 'Content-Type: application/json' -H  "Authorization: Basic $AUTH" -i 'https://oai-input.portal.mardi4nfdi.de/oai-backend/format' --data '{"metadataPrefix":"openaire_swmath","schemaLocation":"https://raw.githubusercontent.com/MaRDI4NFDI/python-zbMathRest2Oai/main/test/data/software/OpenAire-software-reference.xsd","schemaNamespace":"http://datacite.org/schema/kernel-4","identifierXpath":"/identifier"}'

printf "\n\nCreate Format openaire_articles\n\n"
curl --noproxy '*' -X POST -H 'Content-Type: application/json' -H  "Authorization: Basic $AUTH" -i 'https://oai-input.portal.mardi4nfdi.de/oai-backend/format' --data '{"metadataPrefix":"openaire_articles","schemaLocation":"https://raw.githubusercontent.com/MaRDI4NFDI/python-zbMathRest2Oai/main/test/data/articles/reference-OpenAire2.xsd","schemaNamespace":"http://datacite.org/schema/kernel-4","identifierXpath":"/identifier"}'



printf "\n\nCreate Format oai_zb_preview\n\n"
curl --noproxy '*' -X POST -H 'Content-Type: application/json' -H  "Authorization: Basic $AUTH" -i 'https://oai-input.portal.mardi4nfdi.de/oai-backend/format' --data '{"metadataPrefix":"oai_zb_preview","schemaLocation":"https://zbmath.org/OAI/2.0/oai_zb_preview/","schemaNamespace":"https://zbmath.org/zbmath/elements/1.0/","identifierXpath":""}'

printf "\n\n Read all formats\n\n"
curl --noproxy '*' -X GET -H  "Authorization: Basic $AUTH"  'https://oai-input.portal.mardi4nfdi.de/oai-backend/format'