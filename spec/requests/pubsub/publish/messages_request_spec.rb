require "rails_helper"
require "support/examples/pubsub"

RSpec.describe "Pubsub::Publish::Messages", type: :request do
  describe "POST /pubsub/publish" do
    include_examples "pubsub message requests", :post, "/pubsub/publish"
  end
end
