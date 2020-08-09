require "rails_helper"
require "support/examples/request_examples"

RSpec.describe "Pubsub::Deploy::Messages", type: :request do
  describe "POST /pubsub/deploy" do
    include_examples "pubsub message requests", :post, "/pubsub/deploy"
  end
end
