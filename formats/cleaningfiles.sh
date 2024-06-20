#!/bin/bash
AUTH=$(echo -n "$OAI_BASIC_USER:$OAI_BASIC_PASSWORD" | base64)
# This is a test to delete crosswalks. It is working, I could delete the following one:
#curl --noproxy '*' -X DELETE -H  "Authorization: Basic $AUTH" -i 'https://oai-input.portal.mardi4nfdi.de/oai-backend/crosswalk/swmath2datacite2'
# This is a test to delete formats.
#curl --noproxy '*' -X DELETE -H  "Authorization: Basic $AUTH" -i 'https://oai-input.portal.mardi4nfdi.de/oai-backend/format/zbmath_rest_api_software'

# Strange result. This test could change the deleteFlag from False to True. Don't know yet if the item will later disappear:
#curl --noproxy '*' -X DELETE -H  "Authorization: Basic $AUTH" -i "https://oai-input.portal.mardi4nfdi.de/oai-backend/item/oai:swmath.org:544"

#curl --noproxy '*' -v -X DELETE -H 'Content-Type: multipart/form-data' -i 'http://oai-backend:8080/oai-backend/item/oai:swmath.org:544'