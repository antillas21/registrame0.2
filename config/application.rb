require File.expand_path('../boot', __FILE__)

require 'rails/all'
require "fileutils"

Bundler.require(*Rails.groups)

module Registrame02
  class Application < Rails::Application
    config.load_defaults 8.1

    config.autoload_paths += %W(#{config.root}/app/services)
    config.assets.precompile += %w(consolidated.css print.css ie.css consolidated.min.js jquery.min.js rails.js jquery-ui.js ZeroClipboard.js application.min.js application.js)

    config.before_configuration do
      sample = Rails.root.join("config", "sample_app_config.yml")
      target = Rails.root.join("config", "app_config.yml")
      FileUtils.cp(sample, target) unless File.exist?(target)
      Object.const_set(:APP_CONFIG, Rails.application.config_for(:app_config)) unless defined?(APP_CONFIG)
    end
  end
end
