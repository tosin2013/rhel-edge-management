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
export PACKAGES="curl\nnet-tools\npodman\nwget"
export ARCH="x86_64"