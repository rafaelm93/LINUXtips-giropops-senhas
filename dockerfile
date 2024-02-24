# Estágio de compilação
FROM python:3.11.4-alpine3.18 AS builder

WORKDIR /app

COPY requirements.txt .

# Instalação das dependências de compilação
RUN apk add --no-cache bash && \
    pip install --no-cache-dir -r requirements.txt

# Criar o usuário não privilegiado
RUN adduser -D myuser

# Copiar o código fonte
COPY . .

# Configurar permissões para o usuário não privilegiado
RUN chown -R myuser:myuser /app

USER myuser

# Definir as permissões dos arquivos
RUN chmod -R 755 /app

# Estágio de produção
FROM cgr.dev/chainguard/python:latest
WORKDIR /app

# Copiar apenas o código fonte
COPY --from=builder /app .

EXPOSE 5000

CMD ["flask", "run", "--host=0.0.0.0"]
