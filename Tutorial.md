# Splunk Enterprise and Universal Forwarder in Docker

### Directory Structure
- `scripts`  => Directory with scripts and automation logic
- `bareApps` => The template apps which acts as generic repository of Apps
- `buildDir` => Final build Directory with contents specific to the server

### Naming convention
- `es`  => Splunk Enterprise
- `uf`  => Splunk Universal Forwarder
- `clm` => cluster master
- `dep` => deployment manager
- `lic` => License master
- `shc` => search head cluster
- `idx` => indexer
- `fwd` => forwarder

### How to run
- Load the relevant Splunk main docker image into your docker
- Ensure that image is tagged as splunk/splunk:latest
- go into `scripts` directory
- Run relevant script to create apps for all tiers (eg `./es.createApps.sh`)
- This will create apps in buildDir for each tier specific based on the `appMapping.csv`
- Now run the composeGenerator to create docker compose file automatically (eg `./es.composeGenerator.sh`)
- Compose file will be create in the base Directory
- run `make build`  to Build the docker images
- run `make deploy` to deploy the images and start the containers
