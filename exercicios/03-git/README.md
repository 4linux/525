# Git

## 01 - Ignorando Arquivos e Diretórios

Execute o seguinte script na máquina **automation** (basta copiar e colá-lo no terminal:

```bash
mkdir /tmp/repo
cd /tmp/repo
for X in README.md app.pyc app.py requirements.txt; do
	echo 123 > $X
done
mkdir -p {lib,src,bin}
mkdir -p {src,lib}/__pycache__
echo 123 > src/libs.pyc
echo 123 > src/__pycache__/a.py
echo 123 > src/core.py
echo 123 > lib/__pycache__/b.py
echo 123 > lib/libs.py
git init
```

Crie um arquivo `.gitignore` capaz de ignorar os arquivos de final `.pyc` e os diretórios `__pycache__`.

> **Atenção:** Tome cuidado pois os diretórios `src` e `lib` não mostram seus arquivos na listagem do comando `git status`.
