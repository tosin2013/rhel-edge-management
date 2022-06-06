#!/bin/bash
source authenticate-to-api.sh
export IMAGE_NAME=testapp

echo "Getting Status for ${IMAGE_NAME}"
ID=$(curl -s -X 'GET' \
  'https://console.redhat.com/api/edge/v1/images' \
  -H 'accept: application/json' \
  -H 'Authorization: Bearer '$ACTIVE_TOKEN'' | jq '.data[]| select(.Name=="'${IMAGE_NAME}'") | .ID')

echo "${IMAGE_NAME} IMAGE ID: $ID"

echo "Get build status for ${IMAGE_NAME}"
curl -s -X 'GET' \
  'https://console.redhat.com/api/edge/v1/images/528/status' \
  -H 'accept: application/json' \
  -H 'Authorization: Bearer '$ACTIVE_TOKEN'' | jq '.Status'