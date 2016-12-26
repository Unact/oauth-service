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
