#!/bin/bash 
set -xe
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

INSTALLER_ID=$(curl -s -X 'GET' \
  'https://console.redhat.com/api/image-builder/v1/composes' \
  -H 'accept: application/json' \
  -H 'Authorization: Bearer '$ACTIVE_TOKEN'' | jq '.data[0]| select(.image_name=="'${IMAGE_NAME}'") | .InstallerID')

for i in 1 2 3 4 5
do
   echo "Checking iso $i "
  INSTALLER_ID=$(curl -s -X 'GET' \
  'https://console.redhat.com/api/image-builder/v1/composes' \
  -H 'accept: application/json' \
  -H 'Authorization: Bearer '$ACTIVE_TOKEN'' | jq '.data['$i']| select(.image_name=="'${IMAGE_NAME}'") | .ID')
  if [ ! -z ${INSTALLER_ID} ];
  then 
    NEW_ITEM=$i
    break
  fi
done

if [ -z ${INSTALLER_ID} ];
then 
  echo "INSTALLER ID is empty"
  exit 1
fi 

DOWNLOAD_URL=$(curl -s -X 'GET' \
  'https://console.redhat.com/api/image-builder/v1/composes/'${INSTALLER_ID}'' \
  -H 'accept: application/json' \
  -H 'Authorization: Bearer '$ACTIVE_TOKEN'' | jq '.image_status.upload_status.options.url')


# Download the URL
curl -sL "$DOWNLOAD_URL" > "${IMAGE_NAME}.qcow2"