# Resposta

Este exercício tem duas partes, a segunda parte não foi ensinada no curso.

## Parte 01

Será necessário acessar o Gitea em http://172.27.11.10:3000/user/sign_up, criar o usuário **exercicio**, fazer o login com este usuário e então criar o repositório **site**.

> **Observação:** O e-mail pode ser qualquer um, por exemplo **exercicio@example.com**, mas as políticas de senha exigirão uma senha um pouco mais forte do que "4linux".

Em seguida, acesse a máquina **automation** e execute:

```
git clone https://github.com/4linux/4542-site site
cd site
git remote add gitea-http http://172.27.11.10:3000/exercicio/site.git
git push gitea-http master
```

Basta digitar o usuário **exercicio** e senha que você definiu.

## Parte 02

Agora é preciso criar a chave:

```bash
mkdir ~/git-ex02
ssh-keygen -m PEM -N '' -f ~/git-ex02/ex02
```

Extraia a parte pública da chave e cadastre no Gitea dentro do usuário **exercicio**:

```bash
cat ~/git-ex02/ex02
```

Agora vem a parte mais difícil para os novos usuários do git, a configuração do `~/.ssh/config`. Este arquivo contém algumas informações sobre endereços, usuários e chaves utilizadas para acessar outras máquinas e serviços através de SSH. Provavelmente o arquivo ainda não existe, então precisaremos criá-lo:

```bash
vim ~/.ssh/config
```

O conteúdo do arquivo deverá ser o seguinte:

```
Host gitea
Hostname 172.27.11.10
User git
IdentityFile ~/git-ex02/ex02
```

Como nosso repositório está utilizando um endereço IP e não queremos bagunçar as outras conexões, fazendo com que elas utilizem a mesma chave até mesmo para outros propósitos, adicionamos um apelido alí em **host**. Agora precisamos adicionar "este repositório remoto" no nosso repositório local.

```bash
cd ~/site
git remote add gitea-ssh gitea:exercicio/site.git
echo -e '\nPronto!' >> README.md
git add .
git commit -m 'Finalizado exercício'
git push gitea-ssh
```
