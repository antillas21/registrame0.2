# registrame

Event registration for an expo or trade show. The app has three areas: admin configuration, data capture during the event, and a public pre-registration form.

## Setup

Local development runs in Docker Compose. The web container is `ruby:2.3.8` (`platform: linux/amd64`, because that Ruby image has no arm64 build). The database container is `postgres:18-alpine`.

```sh
docker compose up --build
docker compose run --rm web bundle exec rake db:seed
```

The app listens on [http://localhost:3000](http://localhost:3000).

`db:seed` creates an admin user and a demo event and name badge. Sign in with username `admin` and password `password` (email `admin@example.com` also works). Change that password before exposing the app. Running `db:seed` again inserts another event and another name badge; run it once on a fresh database.

`config/app_config.yml` is optional. When it is missing, the app reads `config/sample_app_config.yml`. Set `SECRET_TOKEN` to a string of at least 30 characters in production. Compose sets one for development.

The characterization suite is the check for this branch:

```sh
docker compose run --rm web bundle exec rspec
```

That command uses the `registrame_test` database on Postgres 18. It must exit 0.

## Architecture

The web container and the Postgres 18 container are separate. Compose publishes port 3000 and keeps Postgres data on a named volume mounted at `/var/lib/postgresql` (the Postgres 18 image layout).

- **Public** (`/`, `/people`) lets someone pre-register. A confirmation email goes out when the record saves.
- **Data** (`/data`) is for staff at the event: attendee lists, company search, and name-badge printing. Sign-in is required.
- **Admin** (`/admin`) is limited to users with `admin` set. It configures the event, registration types, interests, sectors, promotions, users, and the name badge.

Primary keys and foreign keys are integers. Postgres 18 is the server because a later change will use its built-in `uuidv7()` function. This branch does not migrate keys to UUID.

A name badge PDF is rendered when a signed-in user requests `/data/people/:id.pdf` or `/companies/:id/people.pdf`. `QrCodePng` writes `public/images/qrcodes/{id}.png` from `Person#mecard` (`MECARD:N:...;TEL:...;EMAIL:...;NOTE:...;;`). `NameBadgePdf` reads the `NameBadge` row at request time and embeds that PNG. Assets stay on Sprockets; `consolidated.css` and the existing jQuery files live in `vendor/assets`.

## Dependencies

| | |
| --- | --- |
| Ruby | 2.3.8 |
| Rails | 3.2.22.5 |
| PostgreSQL | 18 |
| Devise | `~> 2.2.8` |
| Formtastic | `~> 2.2.1` |
| client_side_validations | `~> 3.2.0` |
| client_side_validations-formtastic | `~> 2.2.0` |
| Prawn | `~> 1.3.0` |
| rqrcode | `~> 0.10.1` |
| chunky_png | `~> 1.3.0` |
| pg | `~> 0.21.0` |
| rspec-rails | `~> 2.14.0` |
| jquery-rails | `~> 2.3.0` |
| test-unit | `~> 3.3.0` |

`test-unit` is here because Ruby 2.2 removed the standard-library `test/unit` that rspec-rails 2.14 loads. Search uses `ILIKE` so company and attendee name search stays case-insensitive on Postgres.

Removed from the Rails 3.0 app: `rqr`, `sqlite3-ruby`, `mysql2`, `yaml_db`, `capistrano`, `cucumber-rails`, `capybara`, `factory_girl`, and the vendored `prawnto` plugin.

## Decisions

### 2026-11-25 — `upgrade/rails-3-2` — Rails 3.2.22.5 / Ruby 2.3.8

Each upgrade stop is its own branch stacked on the previous one. Nothing in this upgrade is committed on `master`.

Postgres 18 is the database for every stop so a later migration can use `uuidv7()`. Integer primary keys and foreign keys stay on this branch. Dev auth is `trust` because `pg` 0.21 cannot speak SCRAM. The Postgres 18 data directory is the volume mount `/var/lib/postgresql`.

Rails 3.2 sets `client_min_messages` to `panic` while enabling standard-conforming strings. Postgres 12 and later reject that level. The app rewrites the setting to `error` in `config/environment.rb`, and the container entrypoint patches the same line in the Active Record gem so `rake db:create` (which does not load `environment.rb`) can connect.

`rqr` is replaced by pure-Ruby `rqrcode`. The vendored Prawn 0.8 templates and the `prawnto` plugin are replaced by `NameBadgePdf`, which reads `NameBadge` at request time. Sprockets stays. `uglifier` is not installed; the Ruby 2.3 image has no JavaScript runtime.

The characterization suite in `spec/` is the gate for later stops. Expectations use `expect`, request specs sign in by posting the Devise form, and PDF and PNG responses are checked by their file headers. Cucumber features and FactoryGirl are removed. The test database pool is 1 so request specs and transactional fixtures share one connection. `spec/spec_helper.rb` sets `RAILS_ENV` to `test` so a container started with `RAILS_ENV=development` still hits `registrame_test`.

Formtastic is `~> 2.2.1`, not 2.3. `client_side_validations-formtastic` 2.2 depends on Formtastic `~> 2.2.0`. Mass-assignment whitelist stays off. `User` still lists `attr_accessible` and does not include `:admin`, so the admin flag is set with `update_attribute`. The committed `secret_token` is gone; development uses `SECRET_TOKEN` from the environment.
