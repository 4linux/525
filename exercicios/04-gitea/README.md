# Gitea

## 01 - Trazendo um repositório do Github para o Gitea

Crie um usuário chamado **exercicio** dentro do gitea e um repositório chamado **site** dentro deste usuário.

Clone o repositório https://github.com/4linux/4542-site na máquina **automation** e envio-o via HTTP para o Gitea com o usuário **exercicio** sem remover o **origin**, chame o repositório remoto de **gitea-http**.

## 02 - Utilizando uma chave SSH de forma diferente

Esta parte exigirá um pouco da criatividade do aluno, não se preocupe se não conseguir resolver este exercício, estes passos não foram ensinados no curso e está aqui exatamente como um desafio.

Crie uma nova chave SSH com o seguinte comando:

```bash
mkdir /root/git-ex02
ssh-keygen -m PEM -N '' -f /root/git-ex02/ex02
```
Cadastre a chave no gitea e adicione o repositório remoto através de **ssh** `git@172.27.11.10:exercicio/site.git` no repositório criado no exercício **01**, chame-o de **gitea-ssh**.

Ao invés de utilizar o comando `git config core.sshCommand`, faça da forma mais antiga, modifique o arquivo `/root/.ssh/config` para fazer com que o comando do git para o repositório do Gitea utilize a chave correta.

> **Observação:** O ideal é criar um apelido para o repositório no arquivo `~/.ssh/config` e utilizar este apelido no comando `git remote add ...`.
