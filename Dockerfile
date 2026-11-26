FROM ruby:2.3.8

# Debian Stretch moved to the archive. The official Ruby 2.3 image still points at the old mirrors.
RUN sed -i 's/deb.debian.org/archive.debian.org/g' /etc/apt/sources.list \
 && sed -i 's/security.debian.org/archive.debian.org/g' /etc/apt/sources.list \
 && sed -i '/stretch-updates/d' /etc/apt/sources.list \
 && printf 'Acquire::Check-Valid-Until "false";\nAPT::Get::AllowUnauthenticated "true";\n' > /etc/apt/apt.conf.d/99archive \
 && apt-get update \
 && apt-get install -y --allow-unauthenticated --no-install-recommends build-essential libpq-dev postgresql-client \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN gem install bundler -v 1.17.3 \
 && bundle _1.17.3_ install

COPY . .

COPY docker/entrypoint.sh /usr/local/bin/docker-entrypoint
RUN chmod +x /usr/local/bin/docker-entrypoint

EXPOSE 3000
ENTRYPOINT ["docker-entrypoint"]
CMD ["bundle", "exec", "rails", "server", "-p", "3000"]
