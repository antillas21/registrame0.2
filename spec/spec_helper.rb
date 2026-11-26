ENV["RAILS_ENV"] = "test"
require File.expand_path("../../config/environment", __FILE__)
require "rspec/rails"

Dir[Rails.root.join("spec/support/**/*.rb")].each { |file| require file }

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end
  config.mock_with :rspec
  config.use_transactional_fixtures = true
  config.include RecordHelpers
  config.include SessionHelpers, :type => :request
end
