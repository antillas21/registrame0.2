FROM ruby:3.0.7

# Ruby 3.0.7 is Debian Bullseye. Those mirrors moved to the archive.
RUN sed -i 's/deb.debian.org/archive.debian.org/g' /etc/apt/sources.list \
 && sed -i 's|security.debian.org/debian-security|archive.debian.org/debian-security|g' /etc/apt/sources.list \
 && sed -i '/-updates/d' /etc/apt/sources.list \
 && printf 'Acquire::Check-Valid-Until "false";\nAPT::Get::AllowUnauthenticated "true";\n' > /etc/apt/apt.conf.d/99archive \
 && apt-get update \
 && apt-get install -y --allow-unauthenticated --no-install-recommends build-essential libpq-dev postgresql-client \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN gem install bundler -v 2.4.22 \
 && bundle _2.4.22_ config set force_ruby_platform true \
 && bundle _2.4.22_ install

COPY . .

COPY docker/entrypoint.sh /usr/local/bin/docker-entrypoint
RUN chmod +x /usr/local/bin/docker-entrypoint

EXPOSE 3000
ENTRYPOINT ["docker-entrypoint"]
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]
