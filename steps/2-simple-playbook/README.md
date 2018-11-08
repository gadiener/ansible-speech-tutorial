# Simple Ansible Playbook


## Ansible Inventory

- Hosts in inventory can be grouped arbitrarily. Copy the general host file into our workspace

-------

> cat /etc/ansible/hosts >> hosts

-------

- Hosts file can be in INI or YAML format. You can add some groups and if you wish to use child groups, just define a `[groupname:children]` and add child groups in it

- After formatting the hosts file, replace {NODE IP} with the ip in the hosts from the previous step

-------

> [loadbalancer]

> host0.caffeina.com ansible_host={NODE IP} ansible_user=root

> [application]

> host1.caffeina.com ansible_host={NODE IP} ansible_user=root

> [database]

> host2.caffeina.com ansible_host={NODE IP} ansible_user=root

> [debian:children]

> loadbalancer

> application

> database

-------


## Running playbook

- Run the following command to see the content of your playbook file

-------

> cat nginx.yml

-------

- Let's run the playbook to install NGINX on loadbalancer server

-------

> ansible-playbook -i ./hosts nginx.yml

-------

- Open in a browser `localhost:40000` and you will see the NGINX default page

- Run the following command to see the content of your new playbook file

-------

> cat nginx-debian.yml

-------

- Let's run the playbook to install NGINX on all servers with debian distro installed. Why not?

-------

> ansible-playbook -i ./hosts nginx-debian.yml

-------

- Open in a browser `localhost:40000`, `localhost:40001`, `localhost:40002` and you will see the NGINX default page


## Next

- Let's go to the next step!

-------

> use-step 3

-------
