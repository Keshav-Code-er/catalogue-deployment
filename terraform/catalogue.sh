#!/bin/bash
app_version=$1
echo "app version: $app_version"
dnf install python3.11 && dnf python3.11-pip -y
pip3.11 install ansible botocore boto3
cd /tmp
ansible-pull -U https://github.com/Keshav-Code-er/Ansible-roboshop-roles-tf.git -e component=catalogue -e app_version=$app_version main.yaml
