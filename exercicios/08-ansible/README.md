# Ansible

Existem três exercícios para o Ansible.

## 01 - Ad Hoc

Utilize um comando ad-hoc para baixar o seguinte arquivo https://github.com/4linux/4542-site/archive/master.zip no diretório `/tmp` da máquina **minion** criada nos exercícios de Rundeck.

## 02 - Playbook

O objetivo desta playbook é provisionar um webserver que fornece um jogo 2D de plataforma em HTML5 chamado **elemental one**.

Criar uma playbook que atenda as seguintes exigências:

- A máquina a ser configurada pelo Ansible é a **minion**
- Instale e configure um servidor de **Apache**
- Clone ou baixe e descompacte o repositório https://github.com/4linux/elemental-one.git em /var/www/elemental-one
- Garanta que o serviço do webserver esteja iniciado e seja carregado durante a inicialização da máquina
- Modifique o arquivo `/etc/apache2/sites-enabled/`

Ao final, teste o acesso em http://172.27.11.250.

## 03 - Roles

Os arquivos desta tarefa estão no final das exigências.

Continuar com a playbook acima mas transformá-la em uma role chamada **https-site** que além de já fazer o que fazia anteriormente consiga atender as novas exigências e de uma forma mais genérica para aceitar outras execuções com outros valores:

- O endereço de download do conteúdo do site deverá ser uma variável (no diretório `defaults`)
- O nome dos certificados, diretórios e arquivos de configuração que se chamam **elemental-one** deverão puxar este nome de uma variável chamada `prefix` (no diretório `defaults`)
- Configure um certificado autoassinado x509 (HTTPS) para o webserver (com o arquivo abaixo)
- Tenha um arquivo de configuração para o site que:
  - Deverá estar em `templates` e se chamar `site.conf`
  - Deverá possuir variáveis que indiquem os caminhos dos certificados
  - Deverá ser enviado para /etc/apache2/sites-enabled
- O certificado e a chave deverão estar no diretório `files` da role
- O certificado deverá estar em `/etc/ssl/certs/`
- A chave deverá estar em `/etc/ssl/private/`
- Habilite o módulo **ssl** do apache criando um link simbólico de `/etc/apache2/mods-available/ssl.conf` e `/etc/apache2/mods-available/ssl.load` para `/etc/apache2/mods-enabled/`
- Recarregue o serviço do apache caso exista alterações no arquivo de configuração

Ao final, teste o acesso em https://elemental-one.172-27-11-250.nip.io, lembre-se de aceitar o certificado auto-assinado.

O arquivo de configuração do site é o seguinte:

**elemental-one.conf**

```
<IfModule mod_ssl.c>
    <VirtualHost elemental-one.172-27-11-250.nip.io:443>
        ServerAdmin webmaster@example.com
        
        DocumentRoot /var/www/html
        
        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined
        
        SSLEngine on
        
        
        SSLCertificateFile      /etc/ssl/certs/elemental-one.pem
        SSLCertificateKeyFile /etc/ssl/private/elemental-one.key
    </VirtualHost>
</IfModule>

# vim: syntax=apache ts=4 sw=4 sts=4 sr noet
```

Os certificados são os seguintes:

**elemental-one.pem**

```
-----BEGIN CERTIFICATE-----
MIIFazCCA1OgAwIBAgIUFLcVMeCdF5QGfutC7bCOtg8/51gwDQYJKoZIhvcNAQEL
BQAwRTELMAkGA1UEBhMCQVUxEzARBgNVBAgMClNvbWUtU3RhdGUxITAfBgNVBAoM
GEludGVybmV0IFdpZGdpdHMgUHR5IEx0ZDAeFw0yMDExMTkyMzA4MTZaFw0zMDEx
MTcyMzA4MTZaMEUxCzAJBgNVBAYTAkFVMRMwEQYDVQQIDApTb21lLVN0YXRlMSEw
HwYDVQQKDBhJbnRlcm5ldCBXaWRnaXRzIFB0eSBMdGQwggIiMA0GCSqGSIb3DQEB
AQUAA4ICDwAwggIKAoICAQC88cpXtaocK1QWGjyPz9/Rr3tGyz9bzRjo/H8Z84si
cbaLio2vSIQlW13Qref2mW+FwKtApVoS9oP8YhzbkCmWOSCY1IFbSNLmFsd4VoBu
30xfgP4Yes8f9pY2yEJd6qkjhOD90PI/U/CAv61Z1vym0Yq0T3cEjyytjUer577a
WImvKp3wx1qnFfKgSbNouuubc3uP2i0seotpBKuO5YPapRRMY00mztnHDBh0HJuR
yWBY0xqZs1IcgK09+cqD5o640LrEpUn2/R7XY3L3rMzPZ5yGNotyFc0HFfz/UrTp
Lvrl+LmPBEkxJ/0azT5Y2ujPNsRP5EKT/z7UlNhYslSCGx7xCsOcJhcpPdhJcIV1
T6f4PSuc5u49q5y8Aa11C2mAd0JE3luUnAd/qL7Vt7RBIZGemgz7pDw94pLsL14u
W37DlZo0A9NoKiV8yNGE6+uH2zYb6mlQFZ34R7lHq0eFDWrVUfWjbHbH0f6PvlCy
00rEqm1dBeaFhVWnqpAIbf4cqM3vlojny6LjcTMxJa3LylBOIaQ+uZVWgvv0jXwK
yP+5OnA7GWUdCtgLuXVAOJt+MSMUsSzzvytiOU2XNfNZyJSOkoY8yjk9FdSLi23g
ve34HcXLjO6FktiW3xG9Ec4VkbAHhWPvxrHmtB/gq/MtN1Ne3GGkp5nbNTSMTK3k
IwIDAQABo1MwUTAdBgNVHQ4EFgQUJ2mvkjUIEM80u3mZRRFAnoG0+oQwHwYDVR0j
BBgwFoAUJ2mvkjUIEM80u3mZRRFAnoG0+oQwDwYDVR0TAQH/BAUwAwEB/zANBgkq
hkiG9w0BAQsFAAOCAgEAAO+6OZyuhkwDjxdqluWsMuQBao4ubuNOfRboegoWjOLz
yCGaiiOngQMR9/JG6ic7XsfvML4cLDdJBPhpybSQEGVBaZaGZklHDW8aacxuP+Om
4ZxWpzjaJddr2t0w72+pAQYKvcP/ORDKmlTfAEqdWgO8pwYJtbWre57e1UnzNibh
z/UAZdaSEl4S8UpjGX7M0KNpLNg9cZpxTAj7yYW4pFHH8wSba57OF3gPQCMqUWjd
L3B8Z84atWB7/RHqf7f6IMBdMc0LRfuRKag35pkxpXY3gjvpqh0gOiIeG8GsRpVj
ZSSm8LIWw2Dbjtijx4zuLq3v4PMGlR29eglDiNcKIjBk5VTBiYxbIaRX1IHOPigx
SEDAdVednqO/q1UqHYhT1Ds8AbsA29tif9OfWWn/bfJZaXfgGvFxq//FBX6Rgpgv
n6CUm+dDwGMOcFM43FHPKSBxOHE1CV2kJiB+r0Nj0I8yAJ9f7ZcweWzSMWq4zzNd
lsxKX1Zks6g3EhXpULHuqZbHrvCxxOnJcdIUQnnm9H+ykSctec4D1bz8Ng4LiuwE
UDBGlD4OUJYKMpsG9PtP+a6Ku2zhdvxasN3ZW9ykQRm/2983TxBPAIzn/jVcKMej
+86aZdBTsBLrHtzt1/dOdUCetacFQHs/agXxD40LbN/qtH0SIFDTwGnqXY3WA7M=
-----END CERTIFICATE-----
```

**elemental-one.key**

```
-----BEGIN PRIVATE KEY-----
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
Wtnjzj4YhcGdpTNFd2DmURosxESZUVg=
-----END PRIVATE KEY-----
```
