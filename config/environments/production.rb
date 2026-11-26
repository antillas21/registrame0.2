Registrame02::Application.configure do
  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true
  config.action_dispatch.x_sendfile_header = "X-Sendfile"
  config.serve_static_files = false
  config.assets.compile = false
  config.assets.digest = true
  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify
  config.log_level = :info
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.default_url_options = { :host => APP_CONFIG['host'] }
end
