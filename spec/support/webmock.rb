require 'webmock/rspec'

WebMock.disable_net_connect!(allow: ['selenium:4444', 'test:3001'])
