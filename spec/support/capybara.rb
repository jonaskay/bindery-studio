Capybara.register_driver :selenium_remote do |app|
  Capybara::Selenium::Driver.new(
    app,
    browser: :remote,
    url: "http://#{ENV['SELENIUM_HOST']}:4444/wd/hub",
    desired_capabilities: Selenium::WebDriver::Remote::Capabilities.chrome
  )
end
Capybara.javascript_driver = :selenium_remote

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by(:rack_test)
  end

  config.before(:each, type: :system, js: true) do
    if ENV['SELENIUM_HOST'].nil?
      Capybara.server_host = "localhost"

      driven_by :selenium_chrome_headless
    else
      Capybara.server_host = ENV['TEST_APP_HOST']
      Capybara.server_port = ENV['TEST_APP_PORT']
      Capybara.app_host = "http://#{ENV['TEST_APP_HOST']}:#{ENV['TEST_APP_PORT']}"

      driven_by :selenium_remote
    end
  end
end
