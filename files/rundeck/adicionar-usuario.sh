#!/bin/bash

# sudo useradd -m -d /home/${option.user} -s /bin/bash ${option.user}
# getent passwd ${option.user}

su -c 'mkdir -p ~/.ssh' @option.user@

grep "@option.key@" /home/@option.user@/.ssh/authorized_keys > /dev/null

if [ $? != 0 ]; then
	su -c 'echo "@option.key@" >> ~/.ssh/authorized_keys' @option.user@
	echo 'Chave adicionada'
else
	echo 'Chave já existe'
fi

echo '@option.user@ ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/@option.user@
