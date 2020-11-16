#!/bin/bash

docker container inspect postgres > /dev/null
if [ "$?" -ne 0 ]; then
    echo -e '\e[31mContêiner chamado "postgres" não encontrado\e[0m'
    exit 1
else
    echo -e '\e[32mEncontramos o contêiner!\e[0m'
fi
docker exec -t postgres bash -c 'env' | grep POSTGRES_ | sed 's/\r//g' > /tmp/env
. /tmp/env

for X in 'DB|devops' 'USER|devops' 'PASSWORD|4linux'; do
    SUFIX=$(echo $X | cut -d '|' -f1)
    EXPECTED=$(echo $X | cut -d '|' -f2)
    eval "CURRENT=\$POSTGRES_$SUFIX"
    if [ "$CURRENT" != "$EXPECTED" ]; then
        echo -e "\e[31mVariável POSTGRES_$SUFIX com valor errado: '$CURRENT' deveria ser '$EXPECTED'\e[0m"
        exit 2
    else
        echo -e "\e[32mVariável POSTGRES_$SUFIX com valor correto\e[0m"
    fi
done

docker exec postgres psql -U devops -w devops -c 'CREATE TABLE devops (id SERIAL, nome VARCHAR(255));' &> /dev/null
docker exec postgres psql -U devops -w devops -c "INSERT INTO devops (nome) VALUES ('Infra Ágil') ON CONFLICT DO NOTHING" > /dev/null
echo 'Removendo contêiner para testar persistência...'
docker rm -f postgres > /dev/null
docker run --name postgres -e POSTGRES_PASSWORD=4linux -e POSTGRES_USER=devops -e POSTGRES_DB=devops -v pg_data:/var/lib/postgresql/data -d postgres > /dev/null
echo 'Esperando banco iniciar...'
sleep 10
docker exec postgres psql -U devops -w devops -c "SELECT * FROM devops WHERE nome = 'Infra Ágil' LIMIT 1" -t | grep 'Infra Ágil'
if [ "$?" -ne 0 ]; then
    echo -e '\e[31mNão foi possível acessar o banco de dados, verifique as variáveis e o nome do contêiner\e[0m'
    exit 3
else
    echo -e '\e[32mTudo certo!\e[0m'
fi

