#!/bin/bash

#The examples below use the linux command jq for encoding teh XSLT to JSON for adding it into the curl command
#The package can be installed via yum install jq
#Get the password and export it as OAI_BASIC_PASSWORD
OAI_BASIC_USER=swmath
AUTH=$(echo -n "$OAI_BASIC_USER:$OAI_BASIC_PASSWORD" | base64)
#Create Crosswalk from radar to oai_dc
XSLT_JSON_ENCODED=`cat ../xslt/software/xslt-software-datacite.xslt | jq -Rsa .`
curl --noproxy '*' -X POST -H 'Content-Type: application/json' -H  "Authorization: Basic $AUTH" -i 'https://oai-input.portal.mardi4nfdi.de/oai-backend/crosswalk' --data '{"name":"swmath2datacite2","formatFrom":"zbmath_rest_api_software","formatTo":"datacite_swmath","xsltStylesheet":'"$XSLT_JSON_ENCODED}"'}'

#Create Crosswalk from radar to datacite
#XSLT_JSON_ENCODED=`cat RadarMD-v9-to-DataciteMD-v4_0.xslt | jq -Rsa .`
#curl -X POST -H 'Content-Type: application/json' -i 'http://localhost:8081/oai-backend/crosswalk' --data '{"name":"Radar2datacite","formatFrom":"radar","formatTo":"datacite","xsltStylesheet":'"$XSLT_JSON_ENCODED}"'}'

#Create Crosswalk from rest_api to datacite
## Read the xslt file
XSLT_JSON_ENCODED=`cat ../xslt/articles/xslt-article-Datacite.xslt | jq -Rsa .`
## Delete
#curl -v -X DELETE -H  "Authorization: Basic $AUTH"   https://oai-input.portal.mardi4nfdi.de/oai-backend/crosswalk/software_restapi_to_datacite
#create
curl --noproxy '*' -X POST -H 'Content-Type: application/json' -H  "Authorization: Basic $AUTH" -i 'https://oai-input.portal.mardi4nfdi.de/oai-backend/crosswalk' --data '{"name":"article2datacite","formatFrom":"zbmath_rest_api","formatTo":"datacite","xsltStylesheet":'"$XSLT_JSON_ENCODED}"'}'

#Create Crosswalk from rest_api to dublin core
## Read the xslt file
XSLT_JSON_ENCODED=`cat ../xslt/articles/xslt-article-DublinCore.xslt | jq -Rsa .`
#create
curl --noproxy '*' -X POST -H 'Content-Type: application/json' -H  "Authorization: Basic $AUTH" -i 'https://oai-input.portal.mardi4nfdi.de/oai-backend/crosswalk' --data '{"name":"article2dc","formatFrom":"zbmath_rest_api","formatTo":"oai_dc","xsltStylesheet":'"$XSLT_JSON_ENCODED}"'}'



#Update the data after recreating or push
curl --noproxy '*' -X PUT -H  "Authorization: Basic $AUTH" -i 'https://oai-input.portal.mardi4nfdi.de/oai-backend/crosswalk/article2datacite/process?updateItemTimestamp=true&from=0000-00-00T00:00:00Z&until=2030-05-27T07:05:02Z'
curl --noproxy '*' -X POST -H "Authorization: Basic $AUTH" -i 'https://oai-input.portal.mardi4nfdi.de/oai-backend/reindex/start'

#Read all crosswalk
#curl -X GET 'http://localhost:8081/oai-backend/crosswalk'
curl --noproxy '*' -X GET -H  "Authorization: Basic $AUTH"  'https://oai-input.portal.mardi4nfdi.de/oai-backend/crosswalk'

#Delete specific crosswalk
#curl -v -X DELETE http://localhost:8081/oai-backend/crosswalk/Radar2OAI_DC_v09

#
#curl --noproxy '*' -X POST -H 'Content-Type: application/json' -H  "Authorization: Basic $AUTH" -i 'https://oai-input.portal.mardi4nfdi.de/oai-backend/crosswalk' --data '{"name":"rest2preview","formatFrom":"zbmath_rest_api","formatTo":"oai_zb_preview","xsltStylesheet":'"$XSLT_JSON_ENCODED}"'}'
