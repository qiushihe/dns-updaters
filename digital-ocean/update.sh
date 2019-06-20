#!/bin/bash

DOMAIN=$1
RECORD_ID=$2
API_TOKEN=$3

MY_IP="$(curl -s ifconfig.co)"

curl \
  -s \
  -X PUT \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer ${API_TOKEN}" \
  -d "{\"data\":\"${MY_IP}\"}" \
  "https://api.digitalocean.com/v2/domains/${DOMAIN}/records/${RECORD_ID}"
