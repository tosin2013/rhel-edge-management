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

INSTALLER_ID=$(curl -s -X 'GET' \
  'https://console.redhat.com/api/edge/v1/images' \
  -H 'accept: application/json' \
  -H 'Authorization: Bearer '$ACTIVE_TOKEN'' | jq '.data[]| select(.Name=="'${IMAGE_NAME}'") | .InstallerID')

if [ -z ${INSTALLER_ID} ];
then 
  echo "INSTALLER ID is empty"
  exit 1
fi 

echo "INSTALLER_ID is ${INSTALLER_ID}"
STATUS=$(curl -s -X 'GET' \
  'https://console.redhat.com/api/edge/v1/images' \
  -H 'accept: application/json' \
  -H 'Authorization: Bearer '$ACTIVE_TOKEN'' | jq '.data[]| select(.Name=="'${IMAGE_NAME}'") |select(.InstallerID=='${INSTALLER_ID}') |.Status'  | tr -d '"')

if [ ${STATUS} != "SUCCESS" ];
then 
  echo "${STATUS} does not equal SUCCESS"
  exit 1
fi 
echo ".data[]| select(.Name=="testapp") |select(.InstallerID==118) |.Installer.Status"
echo "INSTALLER_ID is ${INSTALLER_ID}"
STATUS=$(curl -s -X 'GET' \
  'https://console.redhat.com/api/edge/v1/images' \
  -H 'accept: application/json' \
  -H 'Authorization: Bearer '$ACTIVE_TOKEN'' | jq '.data[]| select(.Name=="'${IMAGE_NAME}'") |select(.InstallerID=='${INSTALLER_ID}') |.Installer.Status'  | tr -d '"')

if [ ${STATUS} != "SUCCESS" ];
then 
  echo "${STATUS} does not equal SUCCESS"
  exit 1
fi 


echo "Get IMAGE_BUILD_ISO_URL"
IMAGE_BUILD_ISO_URL=$(curl -s -X 'GET' \
  'https://console.redhat.com/api/edge/v1/images' \
  -H 'accept: application/json' \
  -H 'Authorization: Bearer '$ACTIVE_TOKEN'' | jq '.data[]| select(.Name=="'${IMAGE_NAME}'") |select(.InstallerID=='${INSTALLER_ID}') | .Installer.ImageBuildISOURL'  | tr -d '"')

if [ -z ${IMAGE_BUILD_ISO_URL} ];
then 
  echo "IMAGE_BUILD_ISO_URL is empty"
  exit 1
fi 

echo "ImageBuildISOURL: ${IMAGE_BUILD_ISO_URL}"
curl -OL $IMAGE_BUILD_ISO_URL