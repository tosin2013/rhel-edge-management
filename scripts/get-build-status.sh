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
  -H 'Authorization: Bearer '$ACTIVE_TOKEN'' | jq '.data[0]| select(.Name=="'${IMAGE_NAME}'") | .ID')

echo "${IMAGE_NAME} IMAGE ID: $ID"

echo "Get build status for ${IMAGE_NAME}"
BUILD_STATUS=$(curl -s -X 'GET' \
  'https://console.redhat.com/api/edge/v1/images/'${ID}'/status' \
  -H 'accept: application/json' \
  -H 'Authorization: Bearer '$ACTIVE_TOKEN'' | jq '.Status')

echo $BUILD_STATUS
while [ "$BUILD_STATUS" != '"Ready"' ]; do
BUILD_STATUS=$(curl -s -X 'GET' \
  'https://console.redhat.com/api/edge/v1/images/'${ID}'/status' \
  -H 'accept: application/json' \
  -H 'Authorization: Bearer '$ACTIVE_TOKEN'' | jq '.Status')

 if [ "$BUILD_STATUS" ==  '"ERROR"' ]; then
  echo "Build Error  for ${IMAGE_NAME}"
  exit 1
 fi

  if [ "$BUILD_STATUS" ==  '"SUCCESS"' ]; then
  echo "Build was a $BUILD_STATUS for ${IMAGE_NAME}"
  exit 0
 fi
 sleep 10s
done
