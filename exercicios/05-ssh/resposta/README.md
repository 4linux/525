# Resposta

Vamos criar o usuário na máquina balancer:

```bash
vagrant ssh balancer
sudo -i
useradd -m -d /home/executor -s /bin/bash executor
echo -e '4linux\n4linux\n' | passwd executor
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
systemctl restart sshd
```

Agora crie o script na máquina **automation**:

```bash
cat > /tmp/script.sh <<'EOF'
#!/bin/bash
apt-cache search nginx
systemctl status cron
mkdir /tmp/site
cd /tmp/site
wget https://github.com/4linux/4542-site/archive/master.zip
EOF
```

Execute o script utilizando um subshell da seguinte forma:

```bash
ssh executor@172.27.11.20 "$(cat /tmp/script.sh)"
```

Outra forma de execução poderia ser a seguinte:

```bash
cat /tmp/script.sh | ssh executor@172.27.11.20 bash
```

È possível guardar o conteúdo arquivo em uma variável e utilizar a variável:

```bash
SCRIPT=$(cat /tmp/script.sh)
ssh executor@172.27.11.20 "$SCRIPT"
```
