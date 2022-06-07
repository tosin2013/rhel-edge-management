#!/bin/bash
if [ ! -f rhel-edge-vars.sh ]; then 
 echo "rhel-edge-vars.sh not found. Please copy rhel-edge-vars.sh.example to rhel-edge-vars.sh and update the variables."
fi 

source rhel-edge-vars.sh
source authenticate-to-api.sh

if [ $CREATE_DEVICE_NAME_GROUP == true ]; then 
 ./scripts/create-device-groups.sh
fi 

if [ $CREATE_IMAGE_NAME == true ]; then 
 ./scripts/create-image-name.sh
fi

./scripts/download-iso.sh