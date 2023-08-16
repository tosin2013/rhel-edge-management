#########################################################
## Required Files
export SSH_PUB_KEY_PATH="$HOME/.ssh/id_rsa.pub"
export RH_OFFLINE_TOKEN_PATH="$HOME/rh-api-offline-token"

#########################################################
## Required variables
export DOWNLOAD_TYPE="iso" # qcow2, iso, ova or vmdk
export TEMPLATE_NAME="iso-qcow-request" # iso-qcow-request, demo-request.json see templates directory

#########################################################
## Image Atrributes
export IMAGE_NAME="test-image"
export USERNAME="admin"
export DISTRIBUTION="rhel-92"
export DESCRIPTION="sample description"
export PACKAGES='["curl", "net-tools", "podman", "tar", "bind-utils", "git"]'
export ARCH="x86_64"

#########################################################
## automated management variables
export RHC_ORG_ID="12345678"
export RHC_ACTIVATION_KEY="YOUR_RHC_ACTIVATION_KEY"

#########################################################
## Optional variables
## osinfo-query os
export OS_VARIANT="rhel8.6"
export DEV_VM_NAME="test-dev-vm-$(tr -dc a-z </dev/urandom|head -c 6)"

#########################################################
## Current Kickstart Variables
# https://github.com/RedHatInsights/edge-api/blob/main/templates/templateKickstart.ks
export ENABLE_KICKSTART=true
export DEFAULT_KICKSTART_URL="https://raw.githubusercontent.com/Red-Hat-SE-RTO/rhel-fleet-management/main/inventories/lab/applications/quarkuscoffeeshop-majestic-monolith-fleet-manger/fleet.kspost"
export RHEL_USERNAME="admin@example.com"
export RHEL_PASSWORD="p@$$w0rd"