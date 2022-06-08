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

if [ -z $PACKAGES ]; then
  echo "No packages found. Please set PACKAGES in rhel-edge-vars.sh"
  exit 1
fi

if [ -z $DESCRIPTION ]; then
  echo "No description found. Please set DESCRIPTION in rhel-edge-vars.sh"
  exit 1
fi

if [ -z $DISTRIBUTION ]; then
  echo "No distribution found. Please set DISTRIBUTION in rhel-edge-vars.sh"
  exit 1
fi

if [  -z $ARCH ]; then
  echo "No arch found. Please set ARCH in rhel-edge-vars.sh"
  exit 1
fi

if [ -z $USERNAME ]; then
  echo "No username found. Please set USERNAME in rhel-edge-vars.sh"
  exit 1
fi

if [ -z $SSH_PUB_KEY_PATH ]; then
  echo "No ssh pub key path found. Please set SSH_PUB_KEY_PATH in rhel-edge-vars.sh"
  exit 1
fi

for p in  $(echo $PACKAGES); do
  echo '{"name": "'$p'"}' | tee -a  /tmp/packages.txt
done
IMAGE_PACKAGES=$(cat  /tmp/packages.txt  | jq --slurp .)
echo ${IMAGE_PACKAGES}
rm -rf /tmp/packages.txt

curl 'https://console.redhat.com/api/edge/v1/images' \
  -H 'authority: console.redhat.com' \
  -H 'accept: application/json, text/plain, */*' \
  -H "Authorization: Bearer $ACTIVE_TOKEN" \
  -H 'accept-language: en-US,en;q=0.9' \
  -H 'cache-control: no-cache' \
  -H 'content-type: application/json' \
  -H 'origin: https://console.redhat.com' \
  -H 'referer: https://console.redhat.com/beta/edge/manage-images?create_image=true' \
  --data-raw '{"name":"'${IMAGE_NAME}'","version":0,"description":"'${DESCRIPTION}'","distribution":"'${DISTRIBUTION}'","imageType":"rhel-edge-installer","packages":'${IMAGE_PACKAGES}',"outputTypes":["rhel-edge-installer","rhel-edge-commit"],"commit":{"arch":"'${ARCH}'"},"installer":{"username":"'${USERNAME}'","sshkey":"'$(cat ${SSH_PUB_KEY_PATH}')"}}' \
  --compressed ;
