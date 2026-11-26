require File.expand_path('../application', __FILE__)

config_file = Rails.root.join('config', 'app_config.yml')
config_file = Rails.root.join('config', 'sample_app_config.yml') unless File.exist?(config_file)
APP_CONFIG = YAML.load_file(config_file.to_s)[Rails.env] || {}

# Rails 3.2 sets client_min_messages to "panic", which PostgreSQL 12 and later reject.
require "pg"
class PG::Connection
  alias_method :async_exec_without_panic, :async_exec
  def async_exec(*args)
    if args.first.is_a?(String) && args.first.include?("panic")
      args[0] = args.first.gsub("panic", "error")
    end
    async_exec_without_panic(*args)
  end
end

Registrame02::Application.initialize!
