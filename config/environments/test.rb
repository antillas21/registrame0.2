Registrame02::Application.configure do
  config.cache_classes = true
  config.eager_load = false
  config.consider_all_requests_local = true
  config.action_controller.perform_caching = false
  config.action_dispatch.show_exceptions = false
  config.action_controller.allow_forgery_protection = false
  config.action_mailer.delivery_method = :test
  config.action_mailer.default_url_options = { :host => APP_CONFIG['host'] }
  config.active_support.deprecation = :stderr
  config.public_file_server.enabled = true
  config.public_file_server.headers = { "Cache-Control" => "public, max-age=3600" }
  config.assets.allow_debugging = true
  config.action_controller.action_on_unpermitted_parameters = :raise
  config.secret_key_base = "test-secret-key-base-change-me-0123456789"
end
