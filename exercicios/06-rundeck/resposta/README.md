# Resposta

Este exercício possui três partes.

## 01 - Adicionando o Node

Modifique o `Vagrantfile`, adicionando uma outra máquina:

```ruby
vms = {
  'automation' => {'memory' => '2048', 'cpus' => 2, 'ip' => '10', 'box' => 'debian/buster64', 'provision' => 'automation.sh'},
  'balancer' => {'memory' => '256', 'cpus' => 1, 'ip' => '20', 'box' => 'debian/buster64','provision' => 'balancer.sh'},
  'database' => {'memory' => '512', 'cpus' => 1, 'ip' => '30', 'box' => 'centos/8', 'provision' => 'database.sh'},
  'docker1' => {'memory' => '512', 'cpus' => 1, 'ip' => '100', 'box' => 'debian/buster64', 'provision' => 'docker.sh'},
  'docker2' => {'memory' => '512', 'cpus' => 1, 'ip' => '200', 'box' => 'centos/8', 'provision' => 'docker.sh'},
  'minion' => {'memory' => '256', 'cpus' => 1, 'ip' => '250', 'box' => 'debian/buster64', 'provision' => 'balancer.sh'}
}
```

> **Observação:** Como `provision` escolhemos `balancer.sh` pois trata-se de um arquivo vazio, mas você pode criar um novo arquivo se assim desejar.

Inicie a nova máquina:

```bash
vagrant up minion
``` 

Adicione a parte pública do chave do Rundeck e o usuário rundeck na máquina minion:

```bash
CMD='sudo useradd --system --shell /bin/bash --create-home --home-dir /var/lib/rundeck rundeck'
vagrant ssh minion -c "$CMD"
KEY="$(vagrant ssh automation -c 'sudo cat /root/keys/rundeck.pub' < /dev/null)"
CMD="sudo -u rundeck -s /bin/bash -c \"mkdir -p ~/.ssh && echo '$KEY' > ~/.ssh/authorized_keys\""
vagrant ssh minion -c "$CMD"
```

Adicione o Rundeck ao sudoers:

```bash
CMD="sudo sed 's/vagrant/rundeck/g' /etc/sudoers.d/vagrant | sudo tee /etc/sudoers.d/rundeck"
vagrant ssh minion -c "$CMD"
```

Adicione a máquina no arquivos de nodes do Rundeck em `/var/lib/rundeck/projects/infra-agil/nodes.yml`:

```yml
172.27.11.250:
  nodename: minion
  hostname: 172.27.11.250
  osVersion: 4.19.0-9-amd64
  osFamily: unix
  osArch: amd64
  description: Minion node
  osName: Linux
  username: rundeck
  tags: ['minion']
```

## 02 - Garantindo Idempotência

O script capaz de instalar o nginx e configurar o site é o seguinte:

```bash
#!/bin/bash

for P in git nginx-common nginx; do
        dpkg -l | awk '{print $2}' | grep -E "^$P$" > /dev/null
        if [ $? -ne 0 ]; then
                PACOTES="$PACOTES $P"
        fi
done

if [ -n "$PACOTES" ]; then
        apt-get update
        apt-get install -y $PACOTES
fi

if [ ! -d /var/www/html/.git ]; then
        rm -rf /var/www/html/*
        git clone https://github.com/4linux/4542-site /var/www/html
fi

systemctl start nginx
systemctl enable nginx
```

> **Observação:** Este script não necessariamente garante que o site esteja presente já que é possível apagar o site e manter o diretório `.git`, mas outras verificações seriam capazes de fazer isso.

## 03 - Ignorando as Precauções

Uma leve modificação precisa ser feita no script para aceitar os argumentos do Rundeck:

```bash
#!/bin/bash

for P in git nginx-common nginx; do
        dpkg -l | awk '{print $2}' | grep -E "^$P$" > /dev/null
        if [ $? -ne 0 ]; then
                PACOTES="$PACOTES $P"
        fi
done

if [ -n "$PACOTES" ] || [ "@option.force@" == "yes" ]; then
        apt-get update
        apt-get install -y $PACOTES
fi

if [ ! -d /var/www/html/.git ] || [ "@option.force@" == "yes" ]; then
        find /var/www/html/ -mindepth 1 -delete
        git clone https://github.com/4linux/4542-site /var/www/html
fi

systemctl start nginx
systemctl enable nginx
```

Para facilitar, todo o arquivo YAML de definição do Job:

```yaml
- defaultTab: nodes
  description: ''
  executionEnabled: true
  id: 750982da-5e61-4451-9437-5537bf8b9a89
  loglevel: INFO
  name: Site
  nodeFilterEditable: false
  nodefilters:
    dispatch:
      excludePrecedence: true
      keepgoing: false
      rankOrder: ascending
      successOnEmptyNodeFilter: false
      threadcount: '1'
    filter: 172.27.11.250
  nodesSelectedByDefault: true
  options:
  - label: Force
    name: force
    required: true
    value: 'no'
    values:
    - 'yes'
    - 'no'
    valuesListDelimiter: ','
  plugins:
    ExecutionLifecycle: null
  scheduleEnabled: true
  sequence:
    commands:
    - fileExtension: .sh
      interpreterArgsQuoted: false
      script: |-
        #!/bin/bash

        for P in git nginx-common nginx; do
                dpkg -l | awk '{print $2}' | grep -E "^$P$" > /dev/null
                if [ $? -ne 0 ]; then
                        PACOTES="$PACOTES $P"
                fi
        done

        if [ -n "$PACOTES" ] || [ "@option.force@" == "yes" ]; then
                apt-get update
                apt-get install -y $PACOTES
        fi

        if [ ! -d /var/www/html/.git ] || [ "@option.force@" == "yes" ]; then
                find /var/www/html/ -mindepth 1 -delete
                git clone https://github.com/4linux/4542-site /var/www/html
        fi

        systemctl start nginx
        systemctl enable nginx
      scriptInterpreter: sudo bash
    keepgoing: false
    strategy: node-first
  uuid: exercicio-06
```
