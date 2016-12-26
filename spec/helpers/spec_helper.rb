ENV['RAILS_ENV'] ||= 'test'

require File.expand_path("../../dummy/config/environment.rb", __FILE__)
require 'rspec/rails'
require 'factory_girl_rails'
require "capybara/rails"
require 'capybara/rspec'
require 'support/database_cleaner'
require 'support/factory_girl'
require 'support/capybara'

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/../support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
 config.mock_with :rspec
 config.infer_base_class_for_anonymous_controllers = false
 config.order = "random"
end
