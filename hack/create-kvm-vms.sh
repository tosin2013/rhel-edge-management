#!/bin/bash

#########################################################
## Check for required rhel-edge-vars.sh file
if [ ! -f "./rhel-edge-vars.sh" ]; then
  echo -e "\n===== No rhel-edge-vars.sh file found!\n"
  exit 1
else
  source ./rhel-edge-vars.sh
fi

CP_CPU_CORES="2"
CP_RAM_GB="2"
CP_CPU_SOCKETS="1"
DISK_SIZE="40"
LIBVIRT_VM_PATH="/var/lib/libvirt/images"
# uncomment POWEROFF if RHEL 8.5 or less
# POWEROFF=",on_poweroff=preserve"
if [ ! -f ${LIBVIRT_VM_PATH}/$IMAGE_NAME.iso ];
then 
  sudo cp $IMAGE_NAME.iso  ${LIBVIRT_VM_PATH}/$IMAGE_NAME.iso 
fi 


array=(  containerLANbr0 qubibr0 )
for i in "${array[@]}"
do
  echo "checking for $i"
  INTERFACE=$(ip addr | grep -oE $i | head -1)
	if [[ ${INTERFACE} == 'containerLANbr0' ]];
  then 
    LIBVIRT_NETWORK="bridge=containerLANbr0,model=virtio"
    break
  elif  [[ ${INTERFACE} == 'qubibr0' ]];
  then
    LIBVIRT_NETWORK="bridge=qubibr0,model=virtio"
    break
  else
    echo "${array[@]}  not found please machine with one of the interfaces"
  fi
done

LIBVIRT_LIKE_OPTIONS="--connect=qemu:///system -v --memballoon none --cpu host-passthrough --autostart --noautoconsole --virt-type kvm --features kvm_hidden=on --controller type=scsi,model=virtio-scsi --cdrom=${LIBVIRT_VM_PATH}/$IMAGE_NAME.iso  --os-variant=${OS_VARIANT} --events on_reboot=restart${POWEROFF} --graphics vnc,listen=0.0.0.0,tlsport=,defaultMode='insecure' --network ${LIBVIRT_NETWORK}  --console pty,target_type=serial"
MAC_ADDRESS=$(date +%s | md5sum | head -c 6 | sed -e 's/\([0-9A-Fa-f]\{2\}\)/\1:/g' -e 's/\(.*\):$/\1/' | sed -e 's/^/52:54:00:/')

#########################################################
## Check to see if all the nodes have reported in

echo -e "===== Creating RHEL EDGE Libvirt Infrastructure..."

## See if the disk image already exists
if [[ -f "${LIBVIRT_VM_PATH}/${IMAGE_NAME}-${DEV_VM_NAME}.qcow2" ]]; then
echo -e "  Disk for ${DEV_VM_NAME} already exists on host at ${LIBVIRT_VM_PATH}/${IMAGE_NAME}-${DEV_VM_NAME}.qcow2 ..."
else
echo "  Creating disk for VM ${DEV_VM_NAME} at ${LIBVIRT_VM_PATH}/${IMAGE_NAME}-${DEV_VM_NAME}.qcow2 ..."
sudo qemu-img create -f qcow2 ${LIBVIRT_VM_PATH}/${IMAGE_NAME}-${DEV_VM_NAME}.qcow2 ${DISK_SIZE}G
fi

## Check to see if the VM exists
VIRSH_VM=$(sudo virsh list --all | grep ${IMAGE_NAME}-${DEV_VM_NAME} || true);

if [[ -z "${VIRSH_VM}" ]]; then
    echo "  Creating VM ${DEV_VM_NAME} ..."
    nohup sudo virt-install ${LIBVIRT_LIKE_OPTIONS} --mac="${MAC_ADDRESS}" --name=${IMAGE_NAME}-${DEV_VM_NAME} --vcpus "sockets=${CP_CPU_SOCKETS},cores=${CP_CPU_CORES},threads=1" --memory="$(expr ${CP_RAM_GB} \* 1024)" --disk "size=${DISK_SIZE},path=${LIBVIRT_VM_PATH}/${IMAGE_NAME}-${DEV_VM_NAME}.qcow2,cache=none,format=qcow2" &
    sleep 3
else
    echo "  VM ${DEV_VM_NAME} already exists ..."
fi

