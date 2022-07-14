#!/bin//bash

source rhel-edge-vars.sh

if [ -d ${IMAGE_NAME}_dir ]; then 
    rm -rf ${IMAGE_NAME}_dir
fi

if [ ! -f ${IMAGE_NAME}.iso ]; then
    echo "Image file ${IMAGE_NAME}.iso not found"
    echo "Downloading ${IMAGE_NAME}.iso"
    ./scripts/download-iso.sh || exit $?
fi

mkdir  ${IMAGE_NAME}_dir
cd  ${IMAGE_NAME}_dir
cp ../$IMAGE_NAME.iso fleet_source.iso

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

curl -OL ${DEFAULT_KICKSTART_URL}
mv fleet.kspost template.ks

podman pull quay.io/fleet-management/fleet-iso-util:latest
if [ ${ENABLE_KICKSTART} == true ];
then 
  podman run -it --rm -v $(pwd):/isodir:Z quay.io/fleet-management/fleet-iso-util:latest  /usr/local/bin/fleetkick.sh -k template.ks
else 
  podman run -it --rm -v $(pwd):/isodir:Z quay.io/fleet-management/fleet-iso-util:latest
fi 

cp fleet_out.iso ../${IMAGE_NAME}_fleet_out.iso
rm fleet.kspost fleet_rhc_vars fleet_out.iso
