#########################################################
## Required Files
export SSH_PUB_KEY_PATH="$HOME/.ssh/id_rsa.pub"
export RH_OFFLINE_TOKEN_PATH="$HOME/rh-api-offline-token"

#########################################################
## Required variables
export CREATE_DEVICE_NAME_GROUP=true
export DEVICE_GROUP_NAME="my-device-name-group"
export CREATE_IMAGE=true

#########################################################
## Image Atrributes
export IMAGE_NAME="test-image"
export USERNAME="admin"
export DISTRIBUTION="rhel-85"
export DESCRIPTION="sample description"
export PACKAGES="curl net-tools podman vim tar bind-utils git"
export ARCH="x86_64"

#########################################################
## Optional variables
## osinfo-query os
export OS_VARIANT="rhel8.5"
export DEV_VM_NAME="test-dev-vm"