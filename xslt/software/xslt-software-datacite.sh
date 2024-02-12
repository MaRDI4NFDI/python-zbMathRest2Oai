#!/bin/bash
AUTH=$(echo -n "$OAI_BASIC_USER:$OAI_BASIC_PASSWORD" | base64)
XSLT_ZBMATH_REST_API_DATACITE='cat xslt-software-transformation.xslt | jq -Rsa . '
VAR_XSLT_ZBMATH_REST_API_DATACITE=$(eval "$XSLT_ZBMATH_REST_API_DATACITE")

curl --noproxy '*' -X POST -H 'Content-Type: application/json' -i 'https://oai-input.portal.mardi4nfdi.de/oai-backend/crosswalk' --header "Authorization: Basic $AUTH" --data '{"name":"rest2preview","formatFrom":"zbmath_rest_api","formatTo":datacite","xsltStylesheet":'"$VAR_XSLT_ZBMATH_REST_API_DATACITE}"'}'
