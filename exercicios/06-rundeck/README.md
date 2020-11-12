# Rundeck

## 01 - Adicionando um Node

Crie uma nova máquina no `Vagrantfile` do curso chamada **minion** com **256 MB** de memória RAM e 1 CPU. Utilize a box do `debian/buster64` e configure a vm para utilizar o ip 172.27.11.250.

Adicione esta máquina ao Rundeck.

## 02 - Garantindo Idempotência

Crie um job no Rundeck que configure a máquina do exercício anterior instalando um servidor **nginx** e baixando o site https://github.com/4linux/4542-site.

- O Rundeck deverá instalar o nginx apenas quando o pacote não estiver instalado;
- O site só poderá ser baixado (ou clonado) somente quando o diretório `/var/www/html/` não possuir nenhuma versão do site

## 03 - Ignorando as Precauções

Adicionar um parâmetro no Job anterior chamado **force** que poderá receber apenas o valor "yes" ou "no".

Caso o job seja executado com o parâmetro **force=yes** tanto o pacote do nginx como o site devem ser atualizados.
