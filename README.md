RHEL Edge Deployment 
--------------------
Rhel Edge deployment using https://console.redhat.com/beta/edge/.

## API Documentation
https://console.redhat.com/#components-schemas-Device


## RHEL edge deployments using console.redhat.com
1. Get offline token and save it to `~/rh-api-offline-token`
> [Red Hat API Tokens](https://access.redhat.com/management/api)

```bash
vim ~/rh-api-offline-token
```

2. Ensure there is an SSH Public Key at `~/.ssh/id_rsa.pub`

```bash
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa
```

3. Copy the cluster variables example file and modify as needed
```bash
cp example.rhel-edge-vars.sh rhel-edge-vars.sh
vim rhel-edge-vars.sh
```
## Running bootstrap script
```
./bootstrap.sh
```


## Running bootstrap install manually  
> The bootstrap install script calls the scripts below in order. If you would like to walk thru the script call the scripts below. 
* `scripts/authenticate-to-api.sh` - authenticate to rhel console api 
* `scripts/create-device-groups.sh` - Create device group on the redhat console website
* `scripts/create-image-name.sh` - Create and build rhel image on redhat console.
* `scripts/download-iso.sh` - Download ISO for redhat console
