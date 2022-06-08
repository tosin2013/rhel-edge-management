#!/bin/bash
source authenticate-to-api.sh
source rhel-edge-vars.sh

if [ -z "$ACTIVE_TOKEN" ]; then
  echo "No active token found. Please run authenticate-to-api.sh first."
  exit 1
fi

if [ -z "$IMAGE_NAME" ]; then
  echo "No image name found. Please set IMAGE_NAME in rhel-edge-vars.sh"
  exit 1
fi   

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