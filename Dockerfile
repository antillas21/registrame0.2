FROM ruby:3.3.14

RUN apt-get update \
 && apt-get install -y --no-install-recommends build-essential libpq-dev postgresql-client \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN gem install bundler -v 2.5.23 \
 && bundle _2.5.23_ config set force_ruby_platform true \
 && bundle _2.5.23_ install

COPY . .

COPY docker/entrypoint.sh /usr/local/bin/docker-entrypoint
RUN chmod +x /usr/local/bin/docker-entrypoint

EXPOSE 3000
ENTRYPOINT ["docker-entrypoint"]
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]
