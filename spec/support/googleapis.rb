module Googleapis
  ENDPOINTS = {
    insert_instance: [
      :post,
      "https://compute.googleapis.com/compute/v1/projects/{project}/zones/{zone}/instances?sourceInstanceTemplate=global/instanceTemplates/{template}"
    ],
    oauth: [
      :post,
      "https://www.googleapis.com/oauth2/v4/token"
    ]
  }

  def handle_oauth_request
    Stub.new(:oauth).with_json(
      '{ "access_token": "foo", "expires_in": 3599, "token_type": "Bearer" }'
    )
  end

  def stub(endpoint, expand = {})
    Stub.new(endpoint, expand)
  end

  class Stub
    include WebMock::API

    def initialize(endpoint, expand = {})
      action, url = ENDPOINTS.fetch(endpoint)

      @action = action
      @template = Addressable::Template.new(url).partial_expand(expand)
    end

    def with_json(json, status: 200)
      stub_request(@action, @template).to_return(
        status: status,
        headers: { 'Content-Type' => 'application/json' },
        body: json
      )
    end
  end
end
