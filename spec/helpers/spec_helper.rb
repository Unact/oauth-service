ENV['RAILS_ENV'] ||= 'test'

require File.expand_path("../../dummy/config/environment.rb", __FILE__)
require 'rspec/rails'
require 'factory_girl_rails'
require "capybara/rails"
require 'capybara/rspec'
require 'support/database_cleaner'

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/../support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
 config.mock_with :rspec
 config.infer_base_class_for_anonymous_controllers = false
 config.order = "random"
end

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, :browser => :chrome)
end

Capybara.javascript_driver = :chrome

Capybara.configure do |config|
  config.run_server = true
  config.app_host = "http://localhost:3000"
  config.server_port = 3000
  config.default_max_wait_time = 180
end
