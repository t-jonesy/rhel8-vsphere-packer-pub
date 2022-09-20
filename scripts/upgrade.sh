#!/bin/bash -eux
yum upgrade -y
yum install -y open-vm-tools
yum clean all
reboot now