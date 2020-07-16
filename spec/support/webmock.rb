require 'webmock/rspec'

WebMock.disable_net_connect!(
  allow_localhost: true,
  allow: [
    'http://selenium:4444',
    'http://test:3001',
    'https://chromedriver.storage.googleapis.com'
  ]
)
