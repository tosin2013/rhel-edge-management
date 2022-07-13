#!/bin//bash

source rhel-edge-vars.sh

if [ -d ${IMAGE_NAME}_dir ]; then 
    rm -rf ${IMAGE_NAME}_dir
fi

mkdir  ${IMAGE_NAME}_dir
cd  ${IMAGE_NAME}_dir
mv ../$IMAGE_NAME.iso fleet_source.iso

cat >fleet_rhc_vars<<EOF
RHC_ORGID=${RHC_ORG_ID}
RHC_ACTIVATION_KEY=${RHC_ACTIVATION_KEY}
EOF

if [ ${ENABLE_KICKSTART} == ture ];
then 
  curl -OL ${DEFAULT_KICKSTART_URL}
  sed "s/yourinfo/${RHEL_USERNAME}/g" -i fleet.kspost
  sed "s/yourinfo/${RHEL_PASSWORD}/g" -i fleet.kspost  
fi

podman pull quay.io/fleet-management/fleet-iso-util:latest

podman run -it --rm -v $(pwd):/isodir:Z quay.io/fleet-management/fleet-iso-util:latest

cp fleet_out.iso ../${IMAGE_NAME}_fleet_out.iso
rm fleet.kspost fleet_rhc_vars fleet_out.iso
