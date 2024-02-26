# Definindo a imagem base a partir da qual estamos construindo a imagem atual,
# identificada pelo SHA-256 do digest da imagem. A imagem é nomeada "builder".
FROM cgr.dev/chainguard/python:latest-dev as builder

# Definindo o diretório de trabalho para o próximo comando COPY e RUN.
WORKDIR /giropops-senhas

# Copiando o arquivo requirements.txt do diretório "src" (do contexto de construção)
# para o diretório de trabalho dentro do contêiner.
COPY src/requirements.txt .

# Instalando as dependências listadas no arquivo requirements.txt
# usando o pip. O parâmetro "--user" indica que as dependências devem ser
# instaladas no diretório de usuário local do contêiner.
RUN pip install --no-cache-dir -r requirements.txt --user

# Definindo uma nova etapa de construção baseada em outra imagem base,
# identificada pelo SHA-256 do digest da imagem.
FROM cgr.dev/chainguard/python:latest

# Definindo o diretório de trabalho para o próximo comando COPY.
WORKDIR /giropops-senhas

# Copiando os pacotes instalados do estágio de compilação (etapa "builder")
# para o diretório de trabalho dentro do contêiner.
COPY --from=builder /home/nonroot/.local/lib/python3.12/site-packages /home/nonroot/.local/lib/python3.12/site-packages

# Copiando os arquivos app.py e tailwind.config.js do diretório "src" (do contexto de construção)
# para o diretório de trabalho dentro do contêiner.
COPY src/app.py src/tailwind.config.js ./

# Copiando o diretório "static" do diretório "src" (do contexto de construção)
# para o diretório "static" no diretório de trabalho dentro do contêiner.
COPY src/static ./static

# Copiando o diretório "templates" do diretório "src" (do contexto de construção)
# para o diretório "templates" no diretório de trabalho dentro do contêiner.
COPY src/templates ./templates

# Definindo o comando de entrada (entrypoint) para o contêiner.
# Este comando será executado quando o contêiner for iniciado.
ENTRYPOINT [ "python", "-m" , "flask", "run", "--host=0.0.0.0" ]
