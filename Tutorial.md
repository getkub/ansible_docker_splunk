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
- `sta` => standalone splunk enterprise
- `idx` => indexer
- `fwd` => forwarder

### Operation
####  >> Pre-requisite
- Software Stack => Docker, Docker-compose, Python, Ansible, Linux or MacOs
- Permissions => Root Permissions or equivalent (become in Ansible, to port forward etc, Ability to add your user to docker)
- Load the relevant Splunk and Universal Forwarder docker image into your docker (`docker pull splunk/splunk` ; `docker pull splunk/universalforwarder` )
- Ensure that images are tagged latest  (eg: splunk/splunk:latest)
- Ensure ansible (v2.3+) and ansible-playbook (v2.3+) are installed
- Atleast 20GB of available space in /tmp (or chosen) filesystem (for creating Splunk artefacts.)


####  >> To run this package
Clone the Repository
```
cd ansible
sudo usermod -aG docker $USER
ansible-playbook -i hosts -c local site.yml
```

The above will run and create a Splunk Standalone environment. The script can accept parameters to build `shc`
Refer to  `ansible/example_commands.txt` for further options to run including cluster

## After Cluster is started
- Run `docker ps`  and find the mapping of server to Port. This port is as per mapping in configs
- To access UI as localhost:<port> (eg `http://localhost:9009`)
- Cluster Master & Search Heads will have UI enabled.
- Password is modified to `changed`. Please refer to ansible `group_vars` to change this.
- Note this may take 5 minutes or so as it has to restart few times to configure cluster. Be patient..

### Other Things to note
 - Ensure you always run docker clean command before you exit. Otherwise the docker containers might start automatically in your workstation next time. Clean commands examples in `ansible/example_commands.txt`
 - If you get permission denied errors for `/tmp/jinja/xxx` it is better to delete the whole directory `/tmp/jinja` and start again

 ### TODO (Things pending)
 - Find solution to make Management Console Distributed mode on start. Currently it comes-up as standalone
 - Distribute PEM keys to all search Heads. Partially done.
