#!/bin/bash
until PGPASSWORD=$POSTGRES_PASSWORD psql -h $POSTGRES_HOST -U $POSTGRES_USERNAME -c '\q'; do
  >&2 echo "Postgres is unavailable - sleeping"
  sleep 1
done

>&2 echo "Postgres is up - wait 5 seconds to ensure it's ready"
sleep 5

>&2 echo "bundle install"
bundle install

# Create the database, run migrations and seed the database
bundle exec rails db:create && bundle exec rails db:migrate && bundle exec rails db:seed

# Run migrations for the test database
bundle exec rails db:migrate RAILS_ENV=test

>&2 echo "start server"
rm -f tmp/pids/server.pid && bundle exec puma -C config/puma.rb -p 3000
