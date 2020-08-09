require "rails_helper"
require "support/examples/request_examples"

RSpec.describe "Pubsub::Cleanup::Messages", type: :request do
  describe "POST /pubsub/cleanup" do
    include_examples "pubsub message requests", :post, "/pubsub/cleanup"
  end
end
