RSpec.shared_examples "pubsub message requests" do |action, path|
  before do
    allow(Authenticator).to receive(:validate_token).with("foo")
                                                    .and_return(true)
    allow(Authenticator).to receive(:validate_token).with("invalid")
                                                    .and_return(false)
  end

  let(:publication) { create(:publication) }

  let(:payload) do
    data = Base64.encode64({
      "project" => {
        "id" => publication.id,
        "name" => publication.name
      },
      "status" => "success",
      "timestamp" => "1970-01-01T00:00:00.000Z"
    }.to_json)

    { message: { data: data } }.to_json
  end

  let(:headers) { { "Content-Type" => "application/json", "Authorization" => auth } }

  describe "response" do
    before { send(action, path, { params: payload, headers: headers }) }

    subject { response }

    context "when access token is valid" do
      let(:auth) { "Bearer foo" }

      it { is_expected.to have_http_status(:success) }
    end

    context "when access token is invalid" do
      let(:auth) { "Bearer invalid" }

      it { is_expected.to have_http_status(:unauthorized) }
    end

    context "when access token is missing" do
      let(:auth) { nil }

      it { is_expected.to have_http_status(:bad_request) }
    end
  end
end
