#!/bin/sh
# wait-for-postgres.sh

set -e
  

until PGPASSWORD=$POSTGRESQL_PASSWORD psql -h "$POSTGRESQL_HOST" -U "$POSTGRESQL_USERNAME" -p $POSTGRESQL_PORT -c '\q'; do
  >&2 echo "Postgres is unavailable - sleeping"
  sleep 1
done
  
>&2 echo "Postgres is up - executing command"
python manage.py migrate
python manage.py init_db_data
python manage.py flush --no-input
python manage.py loaddata /mydata/db.json
exec gunicorn -w 4 -b 0.0.0.0 config.wsgi --log-level debug 
