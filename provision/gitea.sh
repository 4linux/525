#!/bin/bash

if [ -f /usr/local/bin/gitea ]; then
	exit
fi

wget -q -O gitea https://dl.gitea.io/gitea/1.12.2/gitea-1.12.2-linux-amd64
chmod +x gitea
useradd --system --shell /bin/bash --comment 'Git Version Control' --home-dir /home/git --create-home git
cp gitea /usr/local/bin/gitea
mkdir -p /var/lib/gitea/{custom,data,log}
chown -R git: /var/lib/gitea/
chmod -R 750 /var/lib/gitea/
mkdir /etc/gitea
chown root:git /etc/gitea
chmod 770 /etc/gitea
cp /vagrant/files/app.ini /etc/gitea/
chown git: /etc/gitea/app.ini

sqlite3 /var/lib/gitea/data/gitea.db < /vagrant/files/gitea.sql
chown git: /var/lib/gitea/data/gitea.db

cp /vagrant/files/gitea.service /etc/systemd/system/gitea.service
systemctl daemon-reload
systemctl start gitea
systemctl enable gitea
