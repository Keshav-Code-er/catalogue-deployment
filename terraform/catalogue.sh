#!/bin/bash
App_version=$1
echo "app version: $App_version"
yum install python3.11-devel python3.11-pip -y
pip3.11 install ansible botocore boto3
cd /tmp
ansible-pull -U https://github.com/Keshav-Code-er/Ansible-roboshop-roles-tf.git -e component=catalogue -e app_version=$App_version main.yaml
