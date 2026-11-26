# registrame

Event registration for an expo or trade show. The app has three areas: admin configuration, data capture during the event, and a public pre-registration form.

## Setup

Local development runs in Docker Compose. The web container is `ruby:3.3.14` and the app server is Puma. The database container is `postgres:18-alpine`. Dev connections use `scram-sha-256`.

```sh
docker compose up --build
docker compose run --rm web bundle exec rake db:seed
```

The app listens on [http://localhost:3000](http://localhost:3000).

`db:seed` creates an admin user and a demo event and name badge. Sign in with username `admin` and password `password` (email `admin@example.com` also works). Change that password before exposing the app. Running `db:seed` again inserts another event and another name badge; run it once on a fresh database.

`config/app_config.yml` is optional. When it is missing, boot copies `config/sample_app_config.yml` and loads it with `Rails.application.config_for`. SMTP settings come from `MAIL_SERVER`, `MAIL_PORT`, `MAIL_USERNAME`, `MAIL_PASSWORD`, `MAIL_AUTH`, `MAIL_STARTTLS`, and `MAIL_DOMAIN` when those are set; otherwise they fall back to the YAML file. Compose sets the development mail values and `SECRET_KEY_BASE`. The encryption key for `config/credentials.yml.enc` stays in `config/master.key`, which is not committed. Set `SECRET_KEY_BASE` to a string of at least 30 characters in production.

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
| Ruby | 3.3.14 |
| Rails | 7.2.4 |
| PostgreSQL | 18 |
| Puma | `~> 6.4` |
| Devise | `~> 4.9.0` |
| Formtastic | `~> 5.0.0` |
| Prawn | `~> 2.5` |
| rqrcode | `~> 2.0` |
| chunky_png | `~> 1.4` |
| pg | `~> 1.5` |
| bootsnap | `>= 1.16.0` |
| rspec-rails | `~> 6.1.0` |
| jquery-rails | `~> 4.6.0` |
| sprockets-rails | `~> 3.4` |

Search uses `ILIKE` so company and attendee name search stays case-insensitive on Postgres. Create and update actions permit their own parameters. Data JSON is built in the models. Styles and scripts stay on Sprockets. `consolidated.css` is plain CSS, so the app does not run it through a Sass compiler.

## Decisions

### 2026-11-25 — `upgrade/rails-7-2` — Rails 7.2.4 / Ruby 3.3.14

`config.load_defaults` was booted at 7.0, then 7.1, then 7.2. The suite stayed green on each group. `rails app:update` kept the existing config files. It added the commented 7.2 framework defaults, a Puma config, and a commented permissions policy. Importmap, Turbo, and Stimulus were not added. Sprockets still serves the stylesheets and scripts, and `jquery-ujs` still handles `method: :delete`.

App settings load with `Rails.application.config_for(:app_config)` before the environment files run. A missing `config/app_config.yml` is copied from the sample. Mail username, password, and SMTP settings prefer the `MAIL_*` environment variables, and Compose sets them for development. `config/secrets.yml` is gone. Tests set `secret_key_base` in the test environment. Development and production use `SECRET_KEY_BASE`. `config/credentials.yml.enc` is committed and `config/master.key` is not.

The Rails 3.2 `client_min_messages` rewrite is gone. Rails 7.2 sets that level to `warning`, which Postgres 18 accepts. Devise is 4.9 and rspec-rails is 6.1. The image is `ruby:3.3.14` on current Debian, so the archive-mirror rewrite used for older Ruby images is not part of this Dockerfile.

### 2026-11-25 — `upgrade/rails-6-1` — Rails 6.1.7.10 / Ruby 3.0.7

`config.load_defaults 6.1` turns on Zeitwerk. `rails zeitwerk:check` eager-loads the app. `update_attributes` is now `update`. Devise is 4.8, Formtastic is 5, and `rqrcode` is 2.x. Puma replaces WEBrick, which Ruby 3.0 no longer ships. `config/boot.rb` loads `logger` because current `concurrent-ruby` no longer does, and Rails 6.1 expects that constant. Sprockets needs `app/assets/config/manifest.js`. The vendored stylesheet is not valid Sass, so `sass-rails` is not installed and `sprockets-rails` serves the existing CSS and JavaScript.

### 2026-11-25 — `upgrade/rails-5-2` — Rails 5.2.8.1 / Ruby 2.6.10

`config.load_defaults` is 5.0 first, then 5.2. Both groups boot and the suite stays green. Models inherit `ApplicationRecord`. Migrations inherit `ActiveRecord::Migration[4.2]` and use instance `up` / `down`. `belongs_to` is required, so a person's company and a company's state, country, and sector are `optional: true`. Registration stays required.

Devise is 4.7 and permits parameters with `permit`. Prawn is 2.x. `pg` is 1.x, so the amd64 pin is gone and Postgres dev auth is `scram-sha-256`. `client_side_validations` is removed, and the forms no longer pass `:validate`. `render_for_api` is replaced by `api_record` / `as_json`, keeping `first_name`, `last_name`, `registration_type`, company `name` / `city` / `state` / `country`, and the `people` and `companies` roots. Request specs pass parameters with the `params:` keyword. `ffi` stays at 1.15.5 because 1.16 does not install on Ruby 2.6.

### 2026-11-25 — `upgrade/rails-4-2` — Rails 4.2.11.3 / Ruby 2.4.10

Strong parameters replace `attr_accessible`. `User` no longer lists accessible attributes, and Devise permits `:login` on sign-in plus `:username` on registration and account updates. Unpermitted parameters raise in development and test. `config/secrets.yml` reads `SECRET_KEY_BASE`. The old `secret_token` initializer is gone.

`before_filter` is now `before_action`. Default scopes are blocks. `find_or_create_by_name` and `find_or_create_by_username` are `find_or_create_by`. The registration mailer calls `deliver_now`. Devise is 3.5 and Formtastic is 3.1. `client_side_validations` stays on the 4.2 line. Its Formtastic adapter never published a release for Formtastic 3, so that extension is not loaded. Devise 3 removed `use_salt_as_remember_token`; the initializer no longer sets it. `loofah` is pinned to 2.20.0 because 2.21 calls `Nokogiri::HTML4`, and the last nokogiri that builds on Ruby 2.4 is 1.10. `rake rails:update` added the Rails 4 binstubs and the cookies, assets, and filter-parameter initializers. Existing config files were kept. Rails 4.2 serves on 127.0.0.1 unless told otherwise, so Compose starts the server with `-b 0.0.0.0`. The amd64 image pin and `trust` Postgres auth stay, because `pg` 0.21 still cannot speak SCRAM.

### 2026-11-25 — `upgrade/rails-3-2` — Rails 3.2.22.5 / Ruby 2.3.8

Each upgrade stop is its own branch stacked on the previous one. Nothing in this upgrade is committed on `master`.

Postgres 18 is the database for every stop so a later migration can use `uuidv7()`. Integer primary keys and foreign keys stay on this branch. Dev auth is `trust` because `pg` 0.21 cannot speak SCRAM. The Postgres 18 data directory is the volume mount `/var/lib/postgresql`.

Rails 3.2 sets `client_min_messages` to `panic` while enabling standard-conforming strings. Postgres 12 and later reject that level. The app rewrites the setting to `error` in `config/environment.rb`, and the container entrypoint patches the same line in the Active Record gem so `rake db:create` (which does not load `environment.rb`) can connect.

`rqr` is replaced by pure-Ruby `rqrcode`. The vendored Prawn 0.8 templates and the `prawnto` plugin are replaced by `NameBadgePdf`, which reads `NameBadge` at request time. Sprockets stays. `uglifier` is not installed; the Ruby 2.3 image has no JavaScript runtime.

The characterization suite in `spec/` is the gate for later stops. Expectations use `expect`, request specs sign in by posting the Devise form, and PDF and PNG responses are checked by their file headers. Cucumber features and FactoryGirl are removed. The test database pool is 1 so request specs and transactional fixtures share one connection. `spec/spec_helper.rb` sets `RAILS_ENV` to `test` so a container started with `RAILS_ENV=development` still hits `registrame_test`.

Formtastic is `~> 2.2.1`, not 2.3. `client_side_validations-formtastic` 2.2 depends on Formtastic `~> 2.2.0`. Mass-assignment whitelist stays off. `User` still lists `attr_accessible` and does not include `:admin`, so the admin flag is set with `update_attribute`. The committed `secret_token` is gone; development uses `SECRET_TOKEN` from the environment.
