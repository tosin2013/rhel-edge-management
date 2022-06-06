#!/bin/bash
source authenticate-to-api.sh
export DEVICE_GROUP_NAME=tosins

curl 'https://console.redhat.com/api/edge/v1/device-groups/' \
  -H "Authorization: Bearer $ACTIVE_TOKEN" \
  -H 'authority: console.redhat.com' \
  -H 'accept: application/json, text/plain, */*' \
  -H 'accept-language: en-US,en;q=0.9' \
  -H 'cache-control: no-cache' \
  -H 'content-type: application/json' \
  --data-raw '{"Name":"'${DEVICE_GROUP_NAME}'","Type":"static"}' \
  --compressed