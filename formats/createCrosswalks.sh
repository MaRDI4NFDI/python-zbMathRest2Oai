#!/bin/bash

# The examples below use the linux command jq for encoding the XSLT to JSON
# The package can be installed via: yum install jq
# Ensure that OAI_BASIC_PASSWORD is set in the environment

# Get the username and password, then export it as OAI_BASIC_PASSWORD
OAI_BASIC_USER="swmath"
AUTH=$(echo -n "$OAI_BASIC_USER:$OAI_BASIC_PASSWORD" | base64)

# Base URL for OAI input
OAI_INPUT="https://oai-input.portal.mardi4nfdi.de/oai-backend/crosswalk"

# Function to execute a crosswalk creation request
create_crosswalk() {
    local name="$1"
    local formatFrom="$2"
    local formatTo="$3"
    local xsltFile="$4"

    # Encode the XSLT file to JSON
    XSLT_JSON_ENCODED=$(cat "$xsltFile" | jq -Rsa .)

    # Execute the curl command
    response=$(curl --noproxy '*' -X POST -H 'Content-Type: application/json' \
                     -H "Authorization: Basic $AUTH" -i $OAI_INPUT \
                     --data "{\"name\":\"$name\",\"formatFrom\":\"$formatFrom\",\"formatTo\":\"$formatTo\",\"xsltStylesheet\":$XSLT_JSON_ENCODED}")

    # Check if the request was successful
    if echo "$response" | grep -q "HTTP/2 200"; then
        echo "Crosswalk $name created successfully."
    else
        echo "Error creating crosswalk $name."
        echo "$response"
    fi
}

# Crosswalk Creation Calls
create_crosswalk "article2dc" "zbmath_rest_api" "oai_dc" "../xslt/articles/xslt-article-DublinCore.xslt"
create_crosswalk "rest2preview" "zbmath_rest_api" "oai_zb_preview" "../xslt/articles/xslt-article-oai_zb_preview.xslt"
create_crosswalk "article2datacite" "zbmath_rest_api" "datacite_articles" "../xslt/articles/xslt-article-Datacite.xslt"
create_crosswalk "swmath2datacite" "zbmath_rest_api_software" "datacite_swmath" "../xslt/software/xslt-software-datacite.xslt"
create_crosswalk "articles2openaire" "zbmath_rest_api" "oai_openaire" "../xslt/articles/xslt-article-OpenAire2.xslt"
create_crosswalk "software2openaire" "zbmath_rest_api_software" "oai_openaire" "../xslt/software/xslt-software-OpenAire.xslt"
create_crosswalk "software2codemeta" "zbmath_rest_api_software" "codemeta" "../xslt/software/xslt-software-Codemeta.xslt"

# Optional: Update the data after recreation or push
# curl --noproxy '*' -X PUT -H  "Authorization: Basic $AUTH" -i 'https://oai-input.portal.mardi4nfdi.de/oai-backend/crosswalk/article2datacite/process?updateItemTimestamp=true&from=0000-00-00T00:00:00Z&until=2030-05-27T07:05:02Z'

# Optional: Start reindexing
# curl --noproxy '*' -X POST -H "Authorization: Basic $AUTH" -i 'https://oai-input.portal.mardi4nfdi.de/oai-backend/reindex/start'

# Optional: Read all crosswalks
# curl --noproxy '*' -X GET -H  "Authorization: Basic $AUTH" $OAI_INPUT

# Optional: Delete a specific crosswalk
# curl -v -X DELETE -H "Authorization: Basic $AUTH" -i 'https://oai-input.portal.mardi4nfdi.de/oai-backend/crosswalk/software2codemeta'
