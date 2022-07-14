#########################################################
## Required Files
export SSH_PUB_KEY_PATH="$HOME/.ssh/id_rsa.pub"
export RH_OFFLINE_TOKEN_PATH="$HOME/rh-api-offline-token"

#########################################################
## Required variables
export CREATE_DEVICE_NAME_GROUP=true
export CREATE_IMAGE=true
export DEVICE_GROUP_NAME="my-device-name-group"

#########################################################
## Image Atrributes
export IMAGE_NAME="test-image"
export USERNAME="admin"
export DISTRIBUTION="rhel-85"
export DESCRIPTION="sample description"
export PACKAGES="curl net-tools podman tar bind-utils git"
export ARCH="x86_64"

#########################################################
## automated management variables
export RHC_ORG_ID="YOUR_RHC_ORG_ID"
export RHC_ACTIVATION_KEY="YOUR_RHC_ACTIVATION_KEY"

#########################################################
## Optional variables
## osinfo-query os
export OS_VARIANT="rhel8.5"
export DEV_VM_NAME="test-dev-vm"

#########################################################
## Current Kickstart Variables
# https://github.com/RedHatInsights/edge-api/blob/main/templates/templateKickstart.ks
export ENABLE_KICKSTART=true
export DEFAULT_KICKSTART_URL="https://raw.githubusercontent.com/Red-Hat-SE-RTO/rhel-fleet-management/main/inventories/lab/applications/quarkuscoffeeshop-majestic-monolith-fleet-manger/fleet.kspost"
export RHEL_USERNAME="admin@example.com"
export RHEL_PASSWORD="p@$$w0rd"