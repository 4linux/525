#!/bin/sh
echo "[+] Atualizando lista de pacotes"
apt update > /dev/null 2>&1

echo "[+] Instalando o Apache e PHP"
apt install apache2 php libapache2-mod-php php-mysql -y > /dev/null 2>&1

echo "[+] Baixando o Wordpress"
wget https://wordpress.org/latest.tar.gz -q

echo "[+] Extraindo Wordpress para a pasta /opt/wordpress"
tar -xf latest.tar.gz -C /var/www/

echo "[+] Configurando o Wordpress"
mv /var/www/wordpress/wp-config-sample.php /var/www/wordpress/wp-config.php
sed -i 's/database_name_here/wordpress/' /var/www/wordpress/wp-config.php
sed -i 's/username_here/wordpressuser/' /var/www/wordpress/wp-config.php
sed -i 's/password_here/4linux/' /var/www/wordpress/wp-config.php
sed -i 's/localhost/10.5.25.101/' /var/www/wordpress/wp-config.php

echo "[+] Alterando o permissionamento do Wordpress"
chown -R root:root /var/www/wordpress

echo "[+] Adicionando o Wordpress ao Apache"
sed -i 's./var/www/html./var/www/wordpress.' /etc/apache2/sites-available/000-default.conf

echo "[+] Reiniciando o Apache"
systemctl restart apache2
