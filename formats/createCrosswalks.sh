#!/bin/bash

#The examples below use the linux command jq for encoding teh XSLT to JSON for adding it into the curl command
#The package can be installed via yum install jq
#Get the password and export it as OAI_BASIC_PASSWORD
OAI_BASIC_USER=swmath
AUTH=$(echo -n "$OAI_BASIC_USER:$OAI_BASIC_PASSWORD" | base64)
OAI_INPUT_STAGING='https://oai-input.staging.mardi4nfdi.org/oai-backend/crosswalk'
OAI_INPUT_PRODUCTION='https://oai-input.portal.mardi4nfdi.de/oai-backend/crosswalk'
OAI_INPUT=$OAI_INPUT_PRODUCTION
#Create Crosswalk from rest_api to dublin core
## Read the xslt file
XSLT_JSON_ENCODED=`cat ../xslt/articles/xslt-article-DublinCore.xslt | jq -Rsa .`
curl --noproxy '*' -X POST -H 'Content-Type: application/json' -H  "Authorization: Basic $AUTH" -i $OAI_INPUT --data '{"name":"article2dc","formatFrom":"zbmath_rest_api","formatTo":"oai_dc","xsltStylesheet":'"$XSLT_JSON_ENCODED}"'}'

#Create Crosswalk from rest_api to oai_zb_preview
XSLT_JSON_ENCODED=`cat ../xslt/articles/xslt-article-oai_zb_preview.xslt | jq -Rsa .`
curl --noproxy '*' -X POST -H 'Content-Type: application/json' -H  "Authorization: Basic $AUTH" -i $OAI_INPUT --data '{"name":"rest2preview","formatFrom":"zbmath_rest_api","formatTo":"oai_zb_preview","xsltStylesheet":'"$XSLT_JSON_ENCODED}"'}'

#Create Crosswalk from rest_api to datacite_articles
XSLT_JSON_ENCODED=`cat ../xslt/articles/xslt-article-Datacite.xslt | jq -Rsa .`
curl --noproxy '*' -X POST -H 'Content-Type: application/json' -H  "Authorization: Basic $AUTH" -i $OAI_INPUT --data '{"name":"article2datacite","formatFrom":"zbmath_rest_api","formatTo":"datacite_articles","xsltStylesheet":'"$XSLT_JSON_ENCODED}"'}'

#Create Crosswalk from zbmath_rest_api_software to datacite_software
XSLT_JSON_ENCODED=$(cat ../xslt/software/xslt-software-datacite.xslt | jq -Rsa .)
curl --noproxy '*' -X POST -H 'Content-Type: application/json' -H  "Authorization: Basic $AUTH" -i $OAI_INPUT --data '{"name":"swmath2datacite","formatFrom":"zbmath_rest_api_software","formatTo":"datacite_swmath","xsltStylesheet":'"$XSLT_JSON_ENCODED}"'}'

#Create Crosswalk from rest_api to oai_openaire
XSLT_JSON_ENCODED=`cat ../xslt/articles/xslt-article-OpenAire2.xslt | jq -Rsa .`
curl --noproxy '*' -X POST -H 'Content-Type: application/json' -H  "Authorization: Basic $AUTH" -i $OAI_INPUT --data '{"name":"articles2openaire","formatFrom":"zbmath_rest_api","formatTo":"oai_openaire","xsltStylesheet":'"$XSLT_JSON_ENCODED}"'}'

#Create Crosswalk from zbmath_rest_api_software to oai_openaire
XSLT_JSON_ENCODED=`cat ../xslt/software/xslt-software-OpenAire.xslt | jq -Rsa .`
curl --noproxy '*' -X POST -H 'Content-Type: application/json' -H  "Authorization: Basic $AUTH" -i $OAI_INPUT --data '{"name":"software2openaire","formatFrom":"zbmath_rest_api_software","formatTo":"oai_openaire","xsltStylesheet":'"$XSLT_JSON_ENCODED}"'}'


#Create Crosswalk from zbmath_rest_api_software to codemeta
XSLT_JSON_ENCODED=`cat ../xslt/software/xslt-software-Codemeta.xslt | jq -Rsa .`
curl --noproxy '*' -X POST -H 'Content-Type: application/json' -H  "Authorization: Basic $AUTH" -i $OAI_INPUT --data '{"name":"software2codemeta","formatFrom":"zbmath_rest_api_software","formatTo":"codemeta","xsltStylesheet":'"$XSLT_JSON_ENCODED}"'}'



#Update the data after recreating or push
# curl --noproxy '*' -X PUT -H  "Authorization: Basic $AUTH" -i 'https://oai-input.portal.mardi4nfdi.de/oai-backend/crosswalk/article2datacite/process?updateItemTimestamp=true&from=0000-00-00T00:00:00Z&until=2030-05-27T07:05:02Z'
# curl --noproxy '*' -X POST -H "Authorization: Basic $AUTH" -i 'https://oai-input.portal.mardi4nfdi.de/oai-backend/reindex/start'

#Read all crosswalk
#curl -X GET 'http://localhost:8081/oai-backend/crosswalk'
curl --noproxy '*' -X GET -H  "Authorization: Basic $AUTH" $OAI_INPUT

#Delete specific crosswalk from por
#curl -v -X DELETE http://localhost:8081/oai-backend/crosswalk/Radar2OAI_DC_v09
#Delete specific crosswalk from local
#curl -v -X DELETE POST -H "Authorization: Basic $AUTH" -i 'https://oai-input.staging.mardi4nfdi.org/oai-backend/crosswalk/software2codemeta'
#
