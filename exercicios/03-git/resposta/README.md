# Resposta

Basta criar um arquivo `.gitignore` com o seguinte conteúdo:

```
*.pyc
__pycache__/
```

O `*.pyc` instrui o git a ignorar todos os arquivos com esta extensão, e especificamente o `__pycache__/` (com um a barra no final) instrui o git a ignorar estes diretórios em qualquer nível da hierarquia.
