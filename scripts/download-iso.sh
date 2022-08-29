#!/bin/bash 
set -xe
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
  -H 'Authorization: Bearer '$ACTIVE_TOKEN'' | jq '.data[0]| select(.Name=="'${IMAGE_NAME}'") | .InstallerID')

for i in 1 2 3 4 5
do
   echo "Welcome $i times"
  INSTALLER_ID=$(curl -s -X 'GET' \
  'https://console.redhat.com/api/edge/v1/images' \
  -H 'accept: application/json' \
  -H 'Authorization: Bearer '$ACTIVE_TOKEN'' | jq '.data['$i']| select(.Name=="'${IMAGE_NAME}'") | .ID')
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

echo "INSTALLER_ID is ${INSTALLER_ID}"
STATUS=$(curl -s -X 'GET' \
  'https://console.redhat.com/api/edge/v1/images' \
  -H 'accept: application/json' \
  -H 'Authorization: Bearer '$ACTIVE_TOKEN'' | jq '.data['${NEW_ITEM}']| select(.Name=="'${IMAGE_NAME}'") |select(.InstallerID=='${INSTALLER_ID}') |.Status'  | tr -d '"')

if [ "${STATUS}" != "SUCCESS" ];
then 
  echo "${STATUS} does not equal SUCCESS"
  exit 1
fi 
echo ".data[0]| select(.Name=="${IMAGE_NAME}") |select(.InstallerID==${INSTALLER_ID}) |.Installer.Status"
echo "INSTALLER_ID is ${INSTALLER_ID}"
STATUS=$(curl -s -X 'GET' \
  'https://console.redhat.com/api/edge/v1/images' \
  -H 'accept: application/json' \
  -H 'Authorization: Bearer '$ACTIVE_TOKEN'' | jq '.data['${NEW_ITEM}']| select(.Name=="'${IMAGE_NAME}'") |select(.InstallerID=='${INSTALLER_ID}') |.Installer.Status'  | tr -d '"')

if [ "${STATUS}" != "SUCCESS" ];
then 
  echo "${STATUS} does not equal SUCCESS"
  exit 1
fi 

curl --location --request GET  \
  'https://console.redhat.com/api/edge/v1/storage/isos/'${INSTALLER_ID} \
  -H 'accept: application/json' \
  -H 'Authorization: Bearer '$ACTIVE_TOKEN'' --output ${IMAGE_NAME}.iso
