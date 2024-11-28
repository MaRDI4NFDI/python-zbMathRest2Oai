#!/bin/bash
AUTH=$(echo -n "$OAI_BASIC_USER:$OAI_BASIC_PASSWORD" | base64)
# This is a test to delete crosswalks. It is working, I could delete the following one:
#curl --noproxy '*' -X DELETE -H  "Authorization: Basic $AUTH" -i 'https://oai-input.portal.mardi4nfdi.de/oai-backend/crosswalk/swmath2datacite2'

# This is a test to delete formats.
#curl --noproxy '*' -X DELETE -H  "Authorization: Basic $AUTH" -i 'https://oai-input.portal.mardi4nfdi.de/oai-backend/format/zbmath_rest_api_software'

# Strange result. This test could change the deleteFlag from False to True. Don't know yet if the item will later disappear:
#curl --noproxy '*' -X DELETE -H  "Authorization: Basic $AUTH" -i "https://oai-input.portal.mardi4nfdi.de/oai-backend/item/oai:swmath.org:544"

#curl --noproxy '*' -v -X DELETE -H 'Content-Type: multipart/form-data' -i 'http://oai-backend:8080/oai-backend/item/oai:swmath.org:544'
#curl --noproxy '*' -v -X DELETE -H 'Content-Type: multipart/form-data' -i 'http://oai-backend:8080/oai-backend/crosswalk/swmath2datacite2'


#In portainer staging, to delete formats, copy-paste:
curl --noproxy '*' -v -X DELETE -H 'Content-Type: multipart/form-data' -i 'http://oai-backend:8080/oai-backend/format/oai_dc'
curl --noproxy '*' -v -X DELETE -H 'Content-Type: multipart/form-data' -i 'http://oai-backend:8080/oai-backend/format/oai_zb_preview'
curl --noproxy '*' -v -X DELETE -H 'Content-Type: multipart/form-data' -i 'http://oai-backend:8080/oai-backend/format/zbmath_rest_api'
curl --noproxy '*' -v -X DELETE -H 'Content-Type: multipart/form-data' -i 'http://oai-backend:8080/oai-backend/format/zbmath_rest_api_software'
curl --noproxy '*' -v -X DELETE -H 'Content-Type: multipart/form-data' -i 'http://oai-backend:8080/oai-backend/format/datacite_articles'
curl --noproxy '*' -v -X DELETE -H 'Content-Type: multipart/form-data' -i 'http://oai-backend:8080/oai-backend/format/datacite_swmath'
curl --noproxy '*' -v -X DELETE -H 'Content-Type: multipart/form-data' -i 'http://oai-backend:8080/oai-backend/format/openaire_articles'
curl --noproxy '*' -v -X DELETE -H 'Content-Type: multipart/form-data' -i 'http://oai-backend:8080/oai-backend/format/openaire_swmath'
curl --noproxy '*' -v -X DELETE -H 'Content-Type: multipart/form-data' -i 'http://oai-backend:8080/oai-backend/format/codemeta'

#In portainer staging, to delete crosswalks, copy-paste:
curl --noproxy '*' -v -X DELETE -H 'Content-Type: multipart/form-data' -i 'http://oai-backend:8080/oai-backend/crosswalk/article2dc'
curl --noproxy '*' -v -X DELETE -H 'Content-Type: multipart/form-data' -i 'http://oai-backend:8080/oai-backend/crosswalk/rest2preview'
curl --noproxy '*' -v -X DELETE -H 'Content-Type: multipart/form-data' -i 'http://oai-backend:8080/oai-backend/crosswalk/article2datacite'
curl --noproxy '*' -v -X DELETE -H 'Content-Type: multipart/form-data' -i 'http://oai-backend:8080/oai-backend/crosswalk/swmath2datacite'
curl --noproxy '*' -v -X DELETE -H 'Content-Type: multipart/form-data' -i 'http://oai-backend:8080/oai-backend/crosswalk/articles2openaire'
curl --noproxy '*' -v -X DELETE -H 'Content-Type: multipart/form-data' -i 'http://oai-backend:8080/oai-backend/crosswalk/software2openaire'
curl --noproxy '*' -v -X DELETE -H 'Content-Type: multipart/form-data' -i 'http://oai-backend:8080/oai-backend/crosswalk/software2codemeta'