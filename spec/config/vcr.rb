require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  c.allow_http_connections_when_no_cassette = true
  c.default_cassette_options = { :record => :new_episodes }
  c.ignore_request do |request|
    # Capybara requests
    URI(request.uri).port == 3999
  end
end
