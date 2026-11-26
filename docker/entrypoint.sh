#!/bin/bash
set -e

host="${POSTGRES_HOST:-db}"
until pg_isready -h "$host" -U registrame >/dev/null 2>&1; do
  echo "waiting for postgres at ${host}"
  sleep 1
done

bundle check || bundle install

bundle exec rake db:create db:migrate
RAILS_ENV=test bundle exec rake db:schema:load

exec "$@"
