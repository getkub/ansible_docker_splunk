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
- Ensure you have relevant permission to update Docker (eg root or docker user)
- Load the relevant Splunk and Universal Forwarder docker image into your docker (`docker pull splunk/splunk` ; `docker pull splunk/universalforwarder` )
- Ensure that images are tagged latest  (eg: splunk/splunk:latest)
- run `make build`  to Build the docker images
- run `make deploy` to deploy the images and start the containers


### Other options
The makefile contains some useful options. Inorder to access those functions, run `make <function>`

Functions are
- `build`  => Builds dockerfile, docker-compose, creates apps and copies to the build
- `deploy` => Starts up all the containers 
- `clean`  => Kills and cleans up all running containers
- `cleanps` => Cleans any hanging processes
- `cleanImages` => Removes all images with a filter. Dangerous and use with caution


