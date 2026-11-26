require File.expand_path('../boot', __FILE__)

require 'rails/all'

if defined?(Bundler)
  Bundler.require(*Rails.groups(:assets => %w(development test)))
end

module Registrame02
  class Application < Rails::Application
    config.encoding = "utf-8"
    config.filter_parameters += [:password]
    config.assets.enabled = true
    config.assets.version = '1.0'
    config.assets.initialize_on_precompile = false

    # Rails 3.2 turns mass-assignment protection on in newly generated apps.
    # These models were written when that protection was off, and strong
    # parameters arrive with the Rails 4 stop.
    config.active_record.whitelist_attributes = false

    config.autoload_paths += %W(#{config.root}/app/services)

    config.assets.precompile += %w(consolidated.css print.css ie.css consolidated.min.js jquery.min.js rails.js jquery-ui.js ZeroClipboard.js application.min.js application.js)
  end
end
