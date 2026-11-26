require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(*Rails.groups)

module Registrame02
  class Application < Rails::Application
    config.load_defaults 5.2

    config.autoload_paths += %W(#{config.root}/app/services)
    config.assets.precompile += %w(consolidated.css print.css ie.css consolidated.min.js jquery.min.js rails.js jquery-ui.js ZeroClipboard.js application.min.js application.js)
  end
end
