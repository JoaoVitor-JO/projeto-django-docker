# pega do dockerhub a imagem do python 3.11 com alpine 3.18
FROM python:3.11-alpine3.18
LABEL mantainer = "JoaoVitor-JO"

#Essa variavel de ambiente faz com que o python não crie no disco arquivos .pyc, que são arquivos de cache do python
# 1 não cria arquivos .pyc, 0 cria arquivos .pyc
ENV PYTHONDONTWRITEBYTECODE 1

#Define que saída do python será exibida imediatamente no terminal, 
#sem armazenar em buffer, útil para ver logs em tempo real
ENV PYTHONUNBUFFERED 1

#cria o diretório /djangoapp dentro do container, onde será copiado o código da aplicação Django(djangoapp)
COPY ./djangoapp /djangoapp

#copia o diretório scripts do projeto para dentro do container, onde estão os scripts
COPY ./scripts /scripts

#Entra no diretório /djangoapp dentro do container, onde está o código da aplicação Django(djangoapp)
WORKDIR /djangoapp

#A porta 8000 é exposta para que a aplicação Django possa ser acessada de fora do container
EXPOSE 8000

# # Cria um ambiente virtual Python dentro do container, instala as dependências do projeto Django
# RUN python -m venv /venv && \
#     /venv/bin/pip install --upgrade pip && \
#     /venv/bin/pip install -r /djangoapp/requirements.txt && \
#     # Cria um usuário no sistema linux da(o) imagem Docker chamado duser sem senha e sem diretório home, 
#     #para rodar a aplicação Django com menos privilégios
#     adduser --disabled-password --no-create-home duser && \

#     # Cria os diretórios /data/web/static e /data/web/media dentro do container,
#     # onde serão armazenados os arquivos estáticos e de mídia da aplicação Django
#     mkdir -p /data/web/static && \
#     mkdir -p /data/web/media && \

#     # Altera o dono dos diretórios /venv, /data/web/static e /data/web/media para o usuário duser,
#     # para que a aplicação Django rode com menos privilégios e não tenha acesso a arquivos do
#     # sistema operacional do container
#     chown -R duser:duser /venv && \
#     chown -R duser:duser /data/web/static && \
#     chown -R duser:duser /data/web/media && \

#     # Altera as permissões dos diretórios /data/web/static e /data/web/media para que o usuário duser
#     # possa ler, escrever e executar arquivos nesses diretórios, e que outros usuários possam apenas
#     # ler e executar arquivos nesses diretórios
#     chmod -R 755 /data/web/static && \
#     chmod -R 755 /data/web/media && \

#     # Altera as permissões do diretório /scripts para que o usuário duser possa ler, escrever e executar
#     # arquivos nesse diretório, e que outros usuários possam apenas ler e executar arquivos nesse diretório
#     chmod -R +x /scripts

RUN python -m venv /venv && \
    /venv/bin/pip install --upgrade pip && \
    /venv/bin/pip install -r /djangoapp/requirements.txt && \
    adduser --disabled-password --no-create-home duser && \
    mkdir -p /data/web/static && \
    mkdir -p /data/web/media && \
    chown -R duser:duser /venv && \
    chown -R duser:duser /data/web/static && \
    chown -R duser:duser /data/web/media && \
    chmod -R 755 /data/web/static && \
    chmod -R 755 /data/web/media && \
    chmod -R +x /scripts
    

# Define a variável de ambiente PATH para incluir o diretório /scripts e o diretório bin do ambiente virtual Python (/venv/bin) no início do PATH, 
# garantindo que os scripts e os executáveis do ambiente virtual sejam encontrados antes dos executáveis do sistema 
# quando o usuário duser executar comandos dentro do container. 
# Isso é importante para garantir que a aplicação Django 
#use as dependências instaladas no ambiente virtual e os scripts personalizados, em vez de depender de versões do sistema operacional do container.
#Dessa fora não é preciso ativar o ambiente virtual, pois o diretório bin do ambiente virtual já está no PATH
ENV PATH = "/scripts:/venv/bin:$PATH"

#Muda o usuário que está rodando o container para duser, que foi criado anteriormente, para que a aplicação Django rode com menos privilégios e não tenha acesso a arquivos do sistema operacional do container
User duser

# Define o comando padrão que será executado quando toda vez que o container for iniciado, que é o script commands.sh, que contém os comandos para rodar a aplicação Django
CMD ["commands.sh"]