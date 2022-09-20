#!/bin/bash -eux
yum upgrade -y
yum install -y open-vm-tools oddjob
systemctl enable --now oddjobd
yum clean all
reboot now