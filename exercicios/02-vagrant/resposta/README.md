# Resposta

O `Vagrantfile` pode ser gerado com `vagrant init centos/8` e então removido todos os comentários desnecessários.

O script de instalação precisava estar dentro do `Vagrantfile`, neste caso utilizamos o próprio exemplo do arquivo gerado alterando os comandos para os desejados. Além de instalar o apache, instalamos o git para fazer um **clone** do repositório no diretório padrão do apache, tomando o cuidado para remover qualquer arquivo ali presente antes da clonagem.

```ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  
  config.vm.box = "centos/8"
  config.vm.box_check_update = false

  config.vm.network "private_network", ip: "172.27.11.150"

  config.vm.provision "shell", inline: <<-SHELL
    dnf install -y httpd git
    cd /var/www/html
    rm -rf *
    git clone https://github.com/4linux/4542-site .
    systemctl start httpd
    systemctl enable httpd
  SHELL
end
```
