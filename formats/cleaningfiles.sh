#!/bin/bash
AUTH=$(echo -n "$OAI_BASIC_USER:$OAI_BASIC_PASSWORD" | base64)
# This is a test to delete crosswalks. It is working, I could delete the following one:
#curl --noproxy '*' -X DELETE -H  "Authorization: Basic $AUTH" -i 'https://oai-input.portal.mardi4nfdi.de/oai-backend/crosswalk/swmath2datacite2'


