#!/bin/bash 

source authenticate-to-api.sh
export IMAGE_NAME=testapp
#https://rh-edge-tarballs-prod.s3.us-east-1.amazonaws.com/6186556/isos/${IMAGE_NAME}.iso


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