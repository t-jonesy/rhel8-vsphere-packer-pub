#!/bin/bash -eux
#setup reqs
yum install -y python3 python39 oddjob
systemctl enable --now oddjobd
authselect select sssd with-mkhomedir --force
#create venv
cd /root/
mkdir python-venv
cd python-venv
python3.9 -m venv ansible
#enter venv
source ansible/bin/activate
#install ansible
python3.9 -m pip install --upgrade pip
python3.9 -m pip install ansible
#get stig role
ansible-galaxy install RedHatOfficial.rhel8_stig -p roles
#create playbook
echo -e "- hosts: all\n  roles:\n     - { role: RedHatOfficial.rhel8_stig }" > playbook.yml
#run playbook
ansible-playbook -i "localhost," -c local playbook.yml | tee /root/ansible-stig.log