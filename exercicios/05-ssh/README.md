# SSH

## 01 - Muitos comandos Remotos

Crie um usuário para acessar a máquina **balancer** através da máquina **automation** chamado "executor". Este usuário poderá acessar através de senha ou chaves SSH.

Temos o seguinte script:

```bash
#!/bin/bash
apt-cache search nginx
systemctl status cron
mkdir /tmp/site
cd /tmp/site
wget https://github.com/4linux/4542-site/archive/master.zip
```

Salve este script em `/tmp/script.sh`.

O objetivo é executar esse script a partir da máquina **automation** dentro da máquina **balancer** sem copiar este arquivo para lá e utilizando no máximo dois comandos.

> **Dica:** Você pode utilizar o subshell para realizar esta tarefa com apenas "1 comando no terminal".
