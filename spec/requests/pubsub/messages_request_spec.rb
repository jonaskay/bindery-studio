require 'rails_helper'

RSpec.describe "Pubsub::Messages", type: :request do
  describe "POST /pubsub/messages" do
    before do
      allow(Authenticator).to receive(:validate_token).with("foo")
                                                      .and_return(true)
      allow(Authenticator).to receive(:validate_token).with("invalid")
                                                      .and_return(false)

      headers = { "Content-Type" => "application/json", "Authorization" => auth }
      data = { publication: create(:site).name, status: "success", timestamp: "1970-01-01T00:00:00.000Z" }
      encoded = Base64.encode64(data.to_json)
      params = { message: { data: encoded } }.to_json

      post "/pubsub/messages", params: params, headers: headers
    end

    context "when access token is valid" do
      let(:auth) { "Bearer foo" }

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end
    end

    context "when access token is invalid" do
      let(:auth) { "Bearer invalid" }

      it "returns http unauthorized" do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "when access token is missing" do
      let(:auth) { nil }

      it "returns http bad request" do
        expect(response).to have_http_status(:bad_request)
      end
    end
  end
end
