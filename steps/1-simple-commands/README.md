# Simple Ansible commands


## Test cluster

- Verify that you have `ansible` installed by running the following command

-------

> ansible --version

-------

- Run the following command to verify that they are up and running

-------

> fping -Ad host0.caffeina.com host1.caffeina.com host2.caffeina.com

-------

- These hosts were already provisioned with the ssh key of this node

-------

> ssh root@host0.caffeina.com -o "StrictHostKeyChecking no" "whoami"

-------

- Run the following command to see the content of your inventory file

-------

> cat /etc/ansible/hosts

-------

- Try to execute the ping module on each host

-------

> ansible -m ping all

-------


## Ansible modules

### Shell

- The following module lets you to execute a shell command on the first remote host

-------

> ansible -m shell -a 'uname -a' host0.caffeina.com

-------

- You can execute this shell command on all remote host

-------

> ansible -m shell -a 'uname -a' all

-------

### Copy

- With this module you can copy a file from the controlling machine to the node

-------

> ansible -m copy -a 'src=/workspace/motd.txt dest=/etc/motd' host0.caffeina.com

-------

- By connecting to ssh you will see the file you just uploaded

-------

> ssh root@host0.caffeina.com -o "StrictHostKeyChecking no"

-------

### Setup

- if you want more information, you can use the setup module

-------

> ansible -m setup host0.caffeina.com

-------

- if you want to know how much memory you have on all your hosts run the following command. You can use `*` in the `filter=` expression. It will act like a shell glob

-------

> ansible -m setup -a 'filter=ansible_memtotal_mb' all

-------


## Next

- Let's go to the next step!

-------

> use-step 2

-------