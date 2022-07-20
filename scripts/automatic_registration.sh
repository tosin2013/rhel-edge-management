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

if [ ${ENABLE_KICKSTART} == true ];
then 
  curl -OL ${DEFAULT_KICKSTART_URL}
  sed "s/rhel_username/${RHEL_USERNAME}/g" -i fleet.kspost
  sed "s/rhel_password/${RHEL_PASSWORD}/g" -i fleet.kspost  
  sed "s/CHANGE_HOSTNAME/${DEV_VM_NAME}/g" -i fleet.kspost  
  sed "s/CHANGE_USERNAME/$USERNAME/g" -i fleet.kspost
  sed "s|CHANGE_SSH|$(cat ${SSH_PUB_KEY_PATH})|g" -i fleet.kspost
  mv fleet.kspost template.ks
  echo "Kickstart file template.ks created"
  echo "#############################################################################"
  cat template.ks
  echo "Kickstart file template.ks contents"
  echo "#############################################################################"
  sleep 10s
fi

podman pull quay.io/fleet-management/fleet-iso-util:latest
chmod 777 -R ../${IMAGE_NAME}_dir/
if [ ${ENABLE_KICKSTART} == true ];
then 
  podman run -it --rm -v $(pwd):/isodir:Z quay.io/fleet-management/fleet-iso-util:latest  /usr/local/bin/fleetkick.sh -k template.ks
else 
  podman run -it --rm -v $(pwd):/isodir:Z quay.io/fleet-management/fleet-iso-util:latest
fi 

cp fleet_out.iso ../${IMAGE_NAME}_${DEV_VM_NAME}.iso
rm fleet_rhc_vars fleet_out.iso
