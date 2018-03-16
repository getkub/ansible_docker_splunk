# Splunk Enterprise and Universal Forwarder in Docker

### Directory Structure
- `ansible` => Directory with ansible playbooks and logic
- `configs` => Configuration directory with mapping and serverList

### Naming convention
- `es`  => Splunk Enterprise
- `uf`  => Splunk Universal Forwarder
- `clm` => cluster master
- `dep` => deployment manager
- `lic` => License master
- `shc` => search head cluster
- `idx` => indexer
- `fwd` => forwarder

### Operation
####  >> Pre-requisite
- Ensure you have relevant permission to update Docker (eg root or docker user)
- Load the relevant Splunk and Universal Forwarder docker image into your docker (`docker pull splunk/splunk` ; `docker pull splunk/universalforwarder` )
- Ensure that images are tagged latest  (eg: splunk/splunk:latest)
- Ensure ansible (v2.3+) and ansible-playbook (v2.3+) are installed


####  >> To run this package
- `cd docker_splunk`  # parent directory
- `ansible-playbook -i hosts -c local site.yml --ask-become-pass` and provide your sudo su password
- PS: Refer to  `ansible/example_commands.txt` for further options to run


### Other Things to note
 - Ensure you always run a clean command before you exit. Otherwise the docker containers might start automatically in your workstation next time.
