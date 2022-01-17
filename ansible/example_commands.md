## To create Standalone from end-to-end (Default is standalone)
```
ansible-playbook -i hosts -c local main_playbooks/sta.yml
``` 

## To create Cluster from end-to-end
```
ansible-playbook -i hosts -c local main_playbooks/shc.yml
```

## For specific roles use tags (To create per component for Testing)
```
ansible-playbook -i hosts -c local main_playbooks/shc.yml "validate_host,set_variables_shc,build_apps"
ansible-playbook -i hosts -c local main_playbooks/shc.yml --tags "validate_host,set_variables_shc,copy_apps"
ansible-playbook -i hosts -c local main_playbooks/shc.yml --tags "validate_host,set_variables_shc,build_apps,docker_splunk_deploy"
```
### In case if you just want to start docker only
```
ansible-playbook -i hosts -c local main_playbooks/shc.yml --tags "validate_host,set_variables_shc,docker_splunk_deploy"
ansible-playbook -i hosts -c local main_playbooks/sta.yml --tags "validate_host,set_variables_sta,docker_splunk_deploy"
```

### Always clean docker instances before your workstation is shutdown
```
ansible-playbook -i hosts -c local main_playbooks/shc.yml --tags "validate_host,set_variables_shc,docker_splunk_clean"
```