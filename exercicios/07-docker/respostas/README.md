# Docker

## Docker Básico

O exercício é resolvido com um único `docker run`:

```bash
docker run --name postgres -e POSTGRES_PASSWORD=4linux -e POSTGRES_USER=devops -e POSTGRES_DB=devops -v pg_data:/var/lib/postgresql/data -d postgres
```

## Imagens

Abaixo temos dois exercícios para criação de imagens, o primeiro é mais simples e o segundo ligeiramente mais complexo. Lembre-se que o código deve ser copiado para dentro do contêiner.

### 01 - Flask

#### Dockerfile

```dockerfile
FROM alpine

COPY . /opt/app

RUN apk add --no-cache py3-pip && pip3 install -r /opt/app/requirements.txt

WORKDIR /opt/app

CMD python3 app.py
```

#### Construção

```bash
git clone https://github.com/4linux/4542-python
cd 4542-python
vim Dockerfile
docker build -t flask .
```

#### Teste

```
docker run -dti --rm --name flask -p 5000:5000 -e APP_HOST=0.0.0.0 flask
curl localhost:5000
```

### 02 - Dancer

Enviar a imagem para o Docker Hub.

```dockerfile
FROM debian:buster-slim

COPY . /opt/app

RUN apt-get update && apt-get install -y perl cpanminus make gcc

WORKDIR /opt/app

RUN cpanm --installdeps .

CMD plackup bin/app.psgi
```

#### Construção

```bash
git clone https://github.com/4linux/4542-perl
cd 4542-perl
vim Dockerfile
docker build -t <usuario>/dancer .
```

#### Docker Hub

```bash
docker login
docker push <usuario>/dancer
```

## Docker Compose

```yml
version: "3.0"

services:
  redis:
    image: redis:alpine
  dancer:
    image: hectorvido/dancer
    environment:
    - "REDIS_SERVER=redis"
    - "REDIS_PORT=6379"
    depends_on:
    - redis
    ports:
    - 8080:5000
```

Para iniciar este compose:

```bash
docker-compose up
```

Para testar se a aplicação modifica a página no redis:

```bash
curl -X POST -H 'Content-Type: application/json' -d '{"html" : "<div id=\"getting-started\"><h1>Atualizado via API REST!</h1><h2>Estes valores foram gravados no Redis</h2><ol><li><h2>HTML Cache</h2><p>É claro que esta pequena página não justifica a utilização do Redis, mas ao menos demonstra a integração entre duas aplicações.</p></li>"}' http://localhost:8080/update
```
