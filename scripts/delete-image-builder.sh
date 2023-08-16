#!/bin/bash

if [ -z $1 ];
then
  echo "No UUID found. ./delete-image-builder.sh d71c7012-d2b9-465a-9a23-f227060c0241"
  exit 1
fi

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

UUID=$1

curl -X 'DELETE' \
  'https://console.redhat.com/api/image-builder/v1/composes/'${UUID}'' \
  -H 'accept: */*' \
  -H 'Authorization: Bearer '$ACTIVE_TOKEN''