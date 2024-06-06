#!/bin/bash

#The examples below use the linux command jq for encoding teh XSLT to JSON for adding it into the curl command
#The package can be installed via yum install jq
AUTH=$(echo -n "$OAI_BASIC_USER:$OAI_BASIC_PASSWORD" | base64)
#Create Crosswalk from radar to oai_dc
XSLT_JSON_ENCODED=`cat ../xslt/software/xslt-software-datacite.xslt | jq -Rsa .`
curl --noproxy '*' -X POST -H 'Content-Type: application/json' -H  "Authorization: Basic $AUTH" -i 'https://oai-input.portal.mardi4nfdi.de/oai-backend/crosswalk' --data '{"name":"swmath2datacite2","formatFrom":"zbmath_rest_api_software2","formatTo":"datacite_swmath","xsltStylesheet":'"$XSLT_JSON_ENCODED}"'}'

#Create Crosswalk from radar to datacite
#XSLT_JSON_ENCODED=`cat RadarMD-v9-to-DataciteMD-v4_0.xslt | jq -Rsa .`
#curl -X POST -H 'Content-Type: application/json' -i 'http://localhost:8081/oai-backend/crosswalk' --data '{"name":"Radar2datacite","formatFrom":"radar","formatTo":"datacite","xsltStylesheet":'"$XSLT_JSON_ENCODED}"'}'


#Read all crosswalk
#curl -X GET 'http://localhost:8081/oai-backend/crosswalk'
curl --noproxy '*' -X GET -H  "Authorization: Basic $AUTH"  'https://oai-input.portal.mardi4nfdi.de/oai-backend/format'

#Delete specific crosswalk
#curl -v -X DELETE http://localhost:8081/oai-backend/crosswalk/Radar2OAI_DC_v09

