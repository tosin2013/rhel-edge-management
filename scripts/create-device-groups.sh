#!/bin/bash
source authenticate-to-api.sh
source rhel-edge-vars.sh

if [ -z "$ACTIVE_TOKEN" ]; then
  echo "No active token found. Please run authenticate-to-api.sh first."
  exit 1
fi

if [ -z $DEVICE_GROUP_NAME ]; then
  echo "No device group name found. Please set DEVICE_GROUP_NAME in rhel-edge-vars.sh"
  exit 1
fi

curl 'https://console.redhat.com/api/edge/v1/device-groups/' \
  -H "Authorization: Bearer $ACTIVE_TOKEN" \
  -H 'authority: console.redhat.com' \
  -H 'accept: application/json, text/plain, */*' \
  -H 'accept-language: en-US,en;q=0.9' \
  -H 'cache-control: no-cache' \
  -H 'content-type: application/json' \
  --data-raw '{"Name":"'${DEVICE_GROUP_NAME}'","Type":"static"}' \
  --compressed