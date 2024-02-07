#!/bin/bash
AUTH=$(echo -n "$OAI_BASIC_USER:$OAI_BASIC_PASSWORD" | base64)
XSLT_RADAR_DATACITE='cat xslt-article-transformation.xslt | jq -Rsa . '
VAR_XSLT_RADAR_DATACITE=$(eval "$XSLT_RADAR_DATACITE")

curl --noproxy '*' -X POST -H 'Content-Type: application/json' -i 'https://oai-input.portal.mardi4nfdi.de/oai-backend/crosswalk' --header "Authorization: Basic $AUTH" --data '{"name":"Radar2OAI_DATACITE3","formatFrom":"zbmath_rest_api","formatTo":"datacite","xsltStylesheet":'"$VAR_XSLT_RADAR_DATACITE}"'}'
