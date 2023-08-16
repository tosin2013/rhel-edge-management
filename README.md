RHEL Edge Deployment 
--------------------
Rhel Edge deployment using https://console.redhat.com/edge/fleet-management.
![20220608160403](https://i.imgur.com/45ww8t5.png)

## API Documentation
https://console.redhat.com/docs/api/edge


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

4. For image-builder use the following template
```bash 
cp example.image-builder-vars.sh image-builder-vars.sh
vim image-builder-vars.sh
```

## Running image-builder install manually
TARGET ENDPOINT: https://console.redhat.com/insights/image-builder`
* `source image-builder-vars.sh && source authenticate-to-api.sh`
* `scripts/create-image-builder.sh` - Create image via image builder
* `scripts/get-image-builder-status.sh` - Get image builder status

## Running bootstrap install manually  
> The bootstrap install script calls the scripts below in order. If you would like to walk thru the script call the scripts below.
TARGET ENDPOINT: https://console.redhat.com/edge/inventory
* `source rhel-edge-vars.sh && source authenticate-to-api.sh`
* `scripts/authenticate-to-api.sh` - authenticate to rhel console api 
* `bash -x scripts/create-device-groups.sh` - Create device group on the redhat console website
* `bash -x scripts/create-image.sh` - Create and build rhel image on redhat console.
* `bash -x scripts/get-build-status.sh` - Wait for build to complete
* `bash -x scripts/download-iso.sh` - Download ISO from redhat console
* `bash -x scripts/automatic_registration.sh` - Auto register vms so they will populate on https://console.redhat.com/insights/inventory/

## Links
* [Create RHEL for Edge images and configure automated management](https://access.redhat.com/documentation/en-us/edge_management/2022/html-single/create_rhel_for_edge_images_and_configure_automated_management/index#doc-wrapper)
* [Working with systems in the edge management application](https://access.redhat.com/documentation/en-us/edge_management/2022/html-single/working_with_systems_in_the_edge_management_application/index)
