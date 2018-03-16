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
- Atleast 1GB of available space in /tmp filesystem (for creating Splunk artefacts.)


####  >> To run this package
- `cd docker_splunk/ansible`  # parent directory
- `ansible-playbook -i hosts -c local site.yml --ask-become-pass` and provide your sudo su password
- PS: Refer to  `ansible/example_commands.txt` for further options to run

## After Cluster is started
- Run `docker ps`  and find the mapping of server to Port. This port is as per mapping in configs
- To access UI as localhost:<port> (eg `http://localhost:9009`)
- Cluster Master & Search Heads will have UI enabled.
- Password is modified to `changed`. Please refer to ansible `group_vars` to change this.
- Note this may take 5 minutes or so as it has to restart few times to configure cluster. Be patient..

### Other Things to note
 - Ensure you always run docker clean command before you exit. Otherwise the docker containers might start automatically in your workstation next time. Clean commands examples in `ansible/example_commands.txt`


 ### TODO (Things pending)
 - Find solution to make Management Console Distributed mode on start. Currently it somes as standalone
 - Distribute PEM keys to all search Heads
