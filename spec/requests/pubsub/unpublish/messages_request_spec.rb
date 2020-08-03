require "rails_helper"
require "support/examples/pubsub"

RSpec.describe "Pubsub::Unpublish::Messages", type: :request do
  describe "POST /pubsub/unpublish" do
    include_examples "pubsub message requests", :post, "/pubsub/unpublish"
  end
end
