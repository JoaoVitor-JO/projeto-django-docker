#tem que colocar o comentario abaixo para que o script seja executado no terminal chamado de shebang
#!/bin/sh


#o shell irá encerrar a execução do script caso ocorra algum erro
set -e


while ! nc -z $POSTGRES_HOST $POSTGRES_PORT; do
  echo "Aguardando o banco de dados PostgreSQL iniciar..."
  sleep 0.1
done

echo "Banco de dados PostgreSQL ($POSTGRES_HOST:$POSTGRES_PORT) iniciado"

python manage.py collectstatic --noinput
python manage.py migrate 
python manage.py runserver 