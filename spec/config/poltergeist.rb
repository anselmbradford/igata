require 'capybara/poltergeist'

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, :timeout => 60, :inspector => true)
end

RSpec.configure do |config|
  config.before(:suite) do
    Capybara.javascript_driver = :poltergeist
  end
end
