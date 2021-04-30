# Jenkins

Este diretório armazena os passos e arquivos para a criação da pipeline final do Curso 525 da 4Linux.

## Requerimentos
Para essa última pipeline, é necessário que você possua uma conta no [Docker HUB](https://hub.docker.com/).

## Aplicação PHP
A aplicação foi clonada do repositório `https://github.com/4linux/4542-php`

## Passo a passo

Clonar repositório

```bash
git clone https://github.com/4linux/4542-php.git
cd 4525
git remote rm origin
```

Após termos is arquivos da aplicação, é hora de criar um repositóŕio no [Gitea](http://172.27.11.10:3000) com o nome "php-login" e do tipo privado para simular o máximo um ambiente real.

Após a criação do repositório, é necessário adicionar o repositório remoto no diretório onde fizemos o clone anteriormente. Então voltaremos no terminal.

```bash
git remote add origin git@172.27.11.10:devops/php-login.git
```

Após termos adicionado o repositório remoto, podemos realizar a configuração para ele utilizar automaticamente a chave que incluimos no gitea nas aulas passadas.

> Caso vocẽ não tenha a chave adicionada, crie um par de chaves (`ssh-keygen -m PEM -N '' -f /root/keys/infra-agil`) e adicione a chave privada dentro do gitea e então rode o comando abaixo.

```bash
git config core.sshCommand "ssh -i /root/keys/infra-agil"
```

Depois da adição da chave, podemos commitar para nosso repositório remoto no gitea esses arquivos que serão utilizados pela esteira do Jenkins.

Vamos criar uma nova pipeline, para isso vamos ao dashboard do Jenkins.
- New Item;
- Nome: php-login
- Tipo: Pipeline
- Ok.
- Discard old build: 10 items
- Em Pipeline, selecionar pipeline script from SCM
- SCM: Git
- Repository URL: git@172.27.11.10:devops/php-login.git

Neste ponto, vamos precisar adicionar a chave pública do Jenkins dentro do Gitea. Após termos adicionado a chave, vamos voltar na criação a pipeline.

- Credentials: jenkins
- Script Path: jenkins/Jenkinsfile.groovy
- Save

Com isso temos o esqueleto para nossa pipeline.

### Ajustes no docker-compose.yml

Será necessário relizar alguns ajustes no docker-compose.yml para subirmos nosso ambiente de teste.

A primeira alteração é trocar a imagem do banco, de "mysql" para "mariadb". Como alteramos a imagem, podemos remover a linha "command".

A próxima alteração é trocar a imagem do serviço "app" para o nome que daremos através do Jenkinsfile. Não será necessário termos as portas mapeadas para o container, então podemos remover esta configuração.

O docker-compose.yml de testes, ficará da seguinte forma:

```yaml
version: '3.3'
services:
   mysql:
     image: mariadb
     environment:
       MYSQL_ROOT_PASSWORD: Abc123!
       MYSQL_DATABASE: php
       MYSQL_USER: php
       MYSQL_PASSWORD: 4linux
   memcached:
     image: memcached:alpine
   app:
     depends_on:
     - mysql
     image: IMAGEM
     environment:
       DB_HOST: mysql
       DB_PORT: 3306
       DB_USER: php
       DB_PASS: 4linux
       DB_NAME: php
```

E por fim, podemos criar uma nova branch onde teremos esta aplicação.

```bash
git checkout -b dev
git add .
git commit -m "Modificado docker-compose.yml"
git push origin dev
```
