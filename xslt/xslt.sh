#!/bin/bash
AUTH=$(echo -n "$OAI_BASIC_USER:$OAI_BASIC_PASSWORD" | base64)
XSLT_RADAR_DC='https://github.com/MaRDI4NFDI/python-zbMathRest2Oai/blob/main/xslt/xslt-article-transformation.xslt'
curl --noproxy '*' -X POST -H 'Content-Type: application/json' -i 'https://oai-input.portal.mardi4nfdi.de/oai-backend/item' --header "Authorization: Basic $AUTH" --data '{"name":"Radar2OAI_DC_v09","formatFrom":"radar","formatTo":"oai_dc","xsltStylesheet":'"$XSLT_RADAR_DC}"'}'
