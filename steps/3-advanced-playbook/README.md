# Advanced Ansible Playbook


## Ansible Inventory

- Recreate the local inventory file

-------

> cat /etc/ansible/hosts >> hosts

-------

- After formatting the hosts file again, remember to replace {NODE IP} with the ip in the hosts from the previous step

-------

> [loadbalancer]

> host0.caffeina.com ansible_host={NODE IP} ansible_user=root

> [application]

> host1.caffeina.com ansible_host={NODE IP} ansible_user=root

> host2.caffeina.com ansible_host={NODE IP} ansible_user=root

> [debian:children]

> loadbalancer

> application

-------

## Running playbook

- Run the following command to see the playbook directories structure

-------

> ls -la roles

-------

- Let's run the playbook to install NGINX on loadbalancer and NGINX+PHP on application server

-------

> ansible-playbook -i ./hosts production.yml

-------

- Open in a browser `localhost:40000` and you will see your php page, if you continuously refresh the browser you'll see the magic happen


## The end

- Thank you for completing this tutorial