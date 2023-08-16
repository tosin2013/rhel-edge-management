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

if [ -z $PACKAGES ]; then
  echo "No packages found. Please set PACKAGES in image-builder-vars.sh"
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

cat >request.json <<END
{
  "image_name": "${IMAGE_NAME}",
  "distribution": "rhel-90",
  "image_requests": [
    {
      "architecture": "x86_64",
      "image_type": "guest-image",
      "upload_request": {
        "type": "aws.s3",
        "options": {}
      }
    }
  ]
}
END


curl --silent \
    --request POST \
    --header "Authorization: Bearer $ACTIVE_TOKEN" \
    --header "Content-Type: application/json" \
    --data @request.json \
    https://console.redhat.com/api/image-builder/v1/compose
