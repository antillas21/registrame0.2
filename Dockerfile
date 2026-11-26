FROM ruby:3.4.13-slim AS build

RUN apt-get update \
 && apt-get install -y --no-install-recommends build-essential libpq-dev \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle config set --global force_ruby_platform true \
 && bundle install

FROM ruby:3.4.13-slim AS runtime

RUN apt-get update \
 && apt-get install -y --no-install-recommends libpq5 \
 && rm -rf /var/lib/apt/lists/* \
 && groupadd --system rails \
 && useradd --system --gid rails --home /app --shell /bin/bash rails

WORKDIR /app

COPY --from=build /usr/local/bundle /usr/local/bundle
COPY . .
COPY docker/entrypoint.sh /usr/local/bin/docker-entrypoint

RUN chmod +x /usr/local/bin/docker-entrypoint \
 && chown -R rails:rails /app /usr/local/bundle

USER rails

EXPOSE 3000
ENTRYPOINT ["docker-entrypoint"]
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]

FROM runtime AS dev

USER root

RUN apt-get update \
 && apt-get install -y --no-install-recommends build-essential libpq-dev \
 && rm -rf /var/lib/apt/lists/*
