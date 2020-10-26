    # Garantindo as chaves
    KEY_PATH='/vagrant/files'
    mkdir -p /root/.ssh
    cp $KEY_PATH/key /root/.ssh/id_rsa
    cp $KEY_PATH/key.pub /root/.ssh/id_rsa.pub
    cp $KEY_PATH/key.pub /root/.ssh/authorized_keys
    chmod 400 /root/.ssh/id_rsa*
    cat /root/.ssh/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys

    # Garantindo os hosts
    HOSTS=$(head -n7 /etc/hosts)
    echo -e "$HOSTS" > /etc/hosts
    echo '10.5.25.10 automation.4labs.example' >> /etc/hosts
    echo '10.5.25.20 compliance.4labs.example' >> /etc/hosts
    echo '10.5.25.30 container.4labs.example chat.4labs.example' >> /etc/hosts
    echo '10.5.25.40 scm.4labs.example' >> /etc/hosts
    echo '10.5.25.50 log.4labs.example' >> /etc/hosts

    # Criando arquivo de SWAP 
    SWAP=$(swapon -v)
    if [ -z "$SWAP" ]; then
      fallocate -l 1G /swapfile
      chmod 600 /swapfile
      mkswap /swapfile
      echo -e "/swapfile swap swap defaults 0 0" >> /etc/fstab
      swapon -a
    fi

