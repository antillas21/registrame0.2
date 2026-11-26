Registrame02::Application.configure do
  config.cache_classes = false
  config.eager_load = false
  config.consider_all_requests_local = true
  config.action_controller.perform_caching = false
  config.action_mailer.raise_delivery_errors = false
  config.active_support.deprecation = :log
  config.active_record.migration_error = :page_load
  config.assets.debug = true
  config.assets.digest = true
  config.action_controller.action_on_unpermitted_parameters = :raise

  config.action_mailer.default_url_options = { :host => APP_CONFIG['host'] }
  config.action_mailer.perform_deliveries = true
  config.action_mailer.delivery_method = :smtp
end
