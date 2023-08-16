#!/bin/bash

source authenticate-to-api.sh
source image-builder-vars.sh

if [ -z "$ACTIVE_TOKEN" ]; then
  echo "No active token found. Please run authenticate-to-api.sh first."
  exit 1
fi

if [ -z "$IMAGE_NAME" ]; then
  echo "No image name found. Please set IMAGE_NAME in image-builder-vars.sh"
  exit 1
fi

if [ -z $DESCRIPTION ]; then
  echo "No description found. Please set DESCRIPTION in image-builder-vars.sh"
  exit 1
fi

if [ -z $DISTRIBUTION ]; then
  echo "No distribution found. Please set DISTRIBUTION in image-builder-vars.sh"
  exit 1
fi

if [  -z $ARCH ]; then
  echo "No arch found. Please set ARCH in image-builder-vars.sh"
  exit 1
fi

if [ -z $USERNAME ]; then
  echo "No username found. Please set USERNAME in image-builder-vars.sh"
  exit 1
fi

if [ -z $SSH_PUB_KEY_PATH ]; then
  echo "No ssh pub key path found. Please set SSH_PUB_KEY_PATH in image-builder-vars.sh"
  exit 1
fi

if [ ${TEMPLATE_NAME} == "demo-request" ];
then
  # Update the JSON using jq
  updated_json=$(echo "templates/demo-request.json" | jq --arg image_name "$IMAGE_NAME" --arg distribution "$DISTRIBUTION" \
  '.image_name = $image_name | .distribution = $distribution')

  # Print the updated JSON
  echo "$updated_json" > request.json
elif [ ${TEMPLATE_NAME} == "iso-qcow-request" ];
then 
    cp iso-qcow-request.json 
    updated_json=$(echo  "templates/iso-qcow-request.json" | jq --arg image_name "$IMAGE_NAME" \
    --arg distribution "$DISTRIBUTION" \
    --arg activation_key "$RHC_ACTIVATION_KEY" \
    --argjson organization "$RHC_ORG_ID" \
    --argjson packages "$PACKAGES" \
    '.image_name = $image_name | 
    .distribution = $distribution | 
    .customizations.subscription["activation-key"] = $activation_key | 
    .customizations.subscription.organization = $organization | 
    .customizations.packages = $packages')

    # Print the updated JSON
    echo "$updated_json" > request.json
else 
  echo "Invalid Template Name"
  exit 1
fi

curl --silent \
    --request POST \
    --header "Authorization: Bearer $ACTIVE_TOKEN" \
    --header "Content-Type: application/json" \
    --data @request.json \
    https://console.redhat.com/api/image-builder/v1/compose
