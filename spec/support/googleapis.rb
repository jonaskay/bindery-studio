module Googleapis
  def handle_oauth_request
    Stub.new(:oauth).with_json(
      '{ "access_token": "foo", "expires_in": 3599, "token_type": "Bearer" }'
    )
  end

  def stub(*endpoint, params: {})
    Stub.new(*endpoint, params: params)
  end

  class Stub
    include WebMock::API

    def initialize(*endpoint, params: {})
      template = Template.new(*endpoint)

      @action = template.action
      @uri = template.uri.expand(params).to_s
    end

    def with_json(json, status: 200)
      stub_request(@action, @uri).to_return(
        status: status,
        headers: { 'Content-Type' => 'application/json' },
        body: json
      )
    end

    def with_status(status)
      stub_request(@action, @uri).to_return(status: status)
    end
  end

  class Template
    ENDPOINTS = {
      compute: {
        insert_instance: [
          :post,
          "https://compute.googleapis.com/compute/v1/projects/{project}/zones/{zone}/instances?sourceInstanceTemplate=global/instanceTemplates/{template}"
        ],
      },
      storage: {
        get_bucket: [
          :get,
          "https://storage.googleapis.com/storage/v1/b/{bucket}"
        ],
        list_objects: [
          :get,
          "https://storage.googleapis.com/storage/v1/b/{bucket}/o?prefix={prefix}"
        ],
        delete_object: [
          :delete,
          "https://storage.googleapis.com/storage/v1/b/{bucket}/o/{object}"
        ]
      },
      oauth: [
        :post,
        "https://www.googleapis.com/oauth2/v4/token"
      ]
    }

    attr_reader :action, :uri

    def initialize(*endpoint)
      action, uri = ENDPOINTS.dig(*endpoint)

      @action = action
      @uri = Addressable::Template.new(uri)
    end
  end
end
