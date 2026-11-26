#!/bin/bash
set -e

host="${POSTGRES_HOST:-db}"
until pg_isready -h "$host" -U registrame >/dev/null 2>&1; do
  echo "waiting for postgres at ${host}"
  sleep 1
done

bundle check || bundle install

# Rails 3.2 sets client_min_messages to "panic" while configuring a connection.
# PostgreSQL 12 and later reject that level. db:create loads Active Record without
# config/environment.rb, so the gem file itself has to be adjusted in this image.
adapter="$(bundle show activerecord)/lib/active_record/connection_adapters/postgresql_adapter.rb"
if [ -f "$adapter" ]; then
  sed -i "s/client_min_messages, 'panic'/client_min_messages, 'error'/" "$adapter"
fi

bundle exec rake db:create db:migrate
RAILS_ENV=test bundle exec rake db:schema:load

exec "$@"
