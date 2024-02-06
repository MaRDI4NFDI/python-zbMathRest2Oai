#Create OAI_DC Format
AUTH=$(echo -ne "$OAI_BASIC_USER:$OAI_BASIC_PASSWORD" | base64)
printf "\n\nCreate Format oai_dc\n\n"
curl --noproxy '*' -X POST -H 'Content-Type: application/json' -H  "Authorization: Basic $AUTH"  -i 'https://oai-input.portal.mardi4nfdi.de/oai-backend/format' --data '{"metadataPrefix":"oai_dc","schemaLocation":"http://www.openarchives.org/OAI/2.0/oai_dc.xsd","schemaNamespace":"http://www.openarchives.org/OAI/2.0/oai_dc/","identifierXpath":"/identifier"}'
