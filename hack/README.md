# Hack-y scripts
## Current Requirements RHEL 8.5

**Optional: configure box**
```
sudo su - admin
curl -OL https://gist.githubusercontent.com/tosin2013/ae925297c1a257a1b9ac8157bcc81f31/raw/71a798d427a016bbddcc374f40e9a4e6fd2d3f25/configure-rhel8.x.sh
chmod +x configure-rhel8.x.sh
./configure-rhel8.x.sh
sudo dnf install libvirt -y
```

### Download and extract the qubinode-installer as a non root user.
> qubinode will quickly configure a kvm enviornment to test with. 
**Download Qubinode Installer**
```
cd $HOME
git clone https://github.com/tosin2013/qubinode-installer.git
cd ~/qubinode-installer
git checkout rhel-8.5
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
