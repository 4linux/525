#!/bin/bash

apt-get update
apt-get install -y vim ansible openjdk-11-jdk gnupg2 curl git sqlite3

# Jenkins
wget -q -O - 'https://pkg.jenkins.io/debian-stable/jenkins.io.key' | apt-key add -
echo 'deb https://pkg.jenkins.io/debian-stable binary/' > /etc/apt/sources.list.d/jenkins.list

# Rundeck
wget -q -O - 'https://bintray.com/user/downloadSubjectPublicKey?username=bintray' | apt-key add -
echo 'deb https://rundeck.bintray.com/rundeck-deb /' > /etc/apt/sources.list.d/rundeck.list

apt-get update
apt-get install -y jenkins rundeck rundeck-cli

# Rundeck
sed -i s/rundeck.projectsStorageType=db/rundeck.projectsStorageType=filesystem/ /etc/rundeck/rundeck-config.properties
sed -i s/admin:admin/devops:4linux/g /etc/rundeck/realm.properties
sed -i s/localhost/172.27.11.10/g /etc/rundeck/framework.properties
sed -i s/localhost/172.27.11.10/g /etc/rundeck/rundeck-config.properties

systemctl enable jenkins rundeckd
systemctl restart jenkins rundeckd

bash /vagrant/provision/gitea.sh &
bash /vagrant/provision/jenkins.sh &
