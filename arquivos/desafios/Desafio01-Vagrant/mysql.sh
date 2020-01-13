#!/bin/sh
echo "[+] Instalando o MariaDB"
yum install mariadb-server -y -q > /dev/null 2>&1

echo "[+] Configurando acesso remoto ao MariaDB"
echo -e "[mysqld]
bind-address=10.5.25.101" > /etc/my.cnf.d/wordpress.cnf

echo "[+] Habilitando o Servico do MariaDB"
systemctl enable mariadb > /dev/null 2>&1

echo "[+] Iniciando o servico do MariaDB"
systemctl start mariadb

echo "[+] Criando o Banco de Dados e usuario Wordpress"
mysql << EOF
CREATE DATABASE wordpress;
USE wordpress;
GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpressuser'@'10.5.25.100' IDENTIFIED BY '4linux';
FLUSH PRIVILEGES;
EOF

echo "[+] Populando a base de dados"
mysql < /vagrant/base.sql
