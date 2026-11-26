require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(*Rails.groups)

module Registrame02
  class Application < Rails::Application
    config.encoding = "utf-8"
    config.filter_parameters += [:password]
    config.assets.enabled = true
    config.assets.version = '1.0'
    config.assets.initialize_on_precompile = false
    config.active_record.raise_in_transactional_callbacks = true

    config.autoload_paths += %W(#{config.root}/app/services)

    config.assets.precompile += %w(consolidated.css print.css ie.css consolidated.min.js jquery.min.js rails.js jquery-ui.js ZeroClipboard.js application.min.js application.js)
  end
end
