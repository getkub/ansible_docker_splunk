## To create Standalone from end-to-end (Default is standalone)
```
ansible-playbook -i hosts -c local main_playbooks/sta.yml
``` 

## To create Universal Forwarders from end-to-end
```
ansible-playbook -i hosts -c local main_playbooks/uf.yml
``` 

## To create Cluster from end-to-end
```
ansible-playbook -i hosts -c local main_playbooks/shc.yml
```

## Adhoc playbooks
```
inputTag="shc"
ansible-playbook -i hosts -c local adhoc_playbooks/app_build.yml -e "inputTag=${inputTag}"
ansible-playbook -i hosts -c local adhoc_playbooks/compose_build.yml -e "inputTag=${inputTag}"
ansible-playbook -i hosts -c local adhoc_playbooks/docker_cleanup_shc.yml
ansible-playbook -i hosts -c local adhoc_playbooks/docker_cleanup_sta.yml
ansible-playbook -i hosts -c local adhoc_playbooks/docker_restart.yml

```
