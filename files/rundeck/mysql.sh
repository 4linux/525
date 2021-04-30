#!/bin/bash

source /etc/os-release

function _debian {
	dpkg -l | grep mariadb-server > /dev/null
	test $? -eq 0 && return
        apt-get update && apt-get install -y --simulate mariadb-server
} 

function _centos {
	rpm -qa | grep mariadb-server > /dev/null
	test $? -eq 0 && return
	dnf install -y mariadb-server
	systemctl start mariadb
	systemctl enable mariadb
}

_$ID
