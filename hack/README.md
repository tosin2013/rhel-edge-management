# Hack-y scripts
## Current Requirements RHEL 8.5

### Download and extract the qubinode-installer as a non root user.
> qubinode will quickly configure a kvm enviornment to test with. 
```
cd $HOME
wget https://github.com/tosin2013/qubinode-installer/archive/refs/heads/assisted-installer.zip
unzip assisted-installer.zip
rm assisted-installer.zip
mv qubinode-installer-assisted-installer qubinode-installer
cd ~/qubinode-installer
```

### Run the qubinode installer to setup the host
```
cd ~/qubinode-installer
./qubinode-installer -m setup
./qubinode-installer -m rhsm
./qubinode-installer -m ansible
./qubinode-installer -m host
./qubinode-installer -m kcli
```

### Create vm to test rhel edge device
```
hack/create-kvm-vms.sh
```