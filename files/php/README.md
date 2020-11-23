# PHP

Esta pequena aplicação faz parte de um dos exercícios do curso de Openshift da 4Linux, e neste caso ela servirá para o curso de Infraestrutura Ágil.

## Dependências

Para o **alpine** precisaremos instalar os seguintes pacotes:

```
php-cli php-mysqli php-session php7-pecl-memcached
```

## Aplicação

Esta aplicação utiliza 5 variáveis de ambiente, todas elas servem para se conectar ao banco de dados:

 - DB_HOST
 - DB_PORT
 - DB_USER
 - DB_NAME
 - DB_PASS

O PHP utiliza o php.ini para configurar o servidor externo de cache, como por exemplo o memcached. Neste caso, dentro do php.ini adicionar:

```ini
[Session]
session.save_handler = memcached
session.save_path = "m1:11211,m2:11211,m3:11211...m9:11211"
```

## MySQL

O banco de ter o seguinte **dump** recuperado:

```sql
-- version 0.1
-- mysql -h 127.0.0.1 -u 'user' -p'password' database < db.sql
-- docker exec -i conteineres_mysql_1 mysql -u php -p'4linux' php < db/dump.sql

DROP TABLE IF EXISTS usuarios;

CREATE TABLE usuarios (
        id INT AUTO_INCREMENT PRIMARY KEY,
        nome VARCHAR(50),
        email VARCHAR(100),
        senha CHAR(60),
        cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

INSERT INTO usuarios (nome, email, senha) VALUES ('Paramahansa Yogananda', 'paramahansa@yogananda.in', '$2y$10$qTdhcJ8CkKztrvRhBN7EG.UB/YqfwjXpV2iKrZjvTIp2HTzqcflvi');
INSERT INTO usuarios (nome, email, senha) VALUES ('Mary Shelley', 'victor@frankenstein.co.uk', '$2y$10$mKvUbxiLFx9V4WPcNT3dWehd9xJ5xyZi2wkmadK8UlJBnYrLpwAqi');
-- Ambas as senhas são um hash de 123
```

Existem várias formas de restaurar o dump, utilize a sua criatividade!

## Testando a Aplicação

Existem dois usuários para testar o login da aplicação:

- paramahansa@yogananda.in com senha **123**
- victor@frankenstein.co.uk com senha **123**
