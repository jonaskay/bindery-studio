require "rails_helper"

RSpec.describe "Tasks::Deployments", type: :request do
  describe "GET /tasks/deployments/check" do
    before { get "/tasks/deployments/check", headers: headers, env: env }

    describe "response" do
      subject { response }

      context "when headers are valid" do
        let(:headers) { { "X-Appengine-Cron": true } }

        context "when client IP is valid" do
          let(:env) { { "HTTP_X_FORWARDED_FOR": "0.1.0.1" } }

          it { is_expected.to have_http_status(:success) }
        end

        context "when client IP is invalid" do
          let(:env) { nil }

          it { is_expected.to have_http_status(:forbidden) }
        end
      end

      context "when headers are invalid" do
        let(:headers) { nil }
        let(:env) { nil }

        it { is_expected.to have_http_status(:bad_request) }
      end
    end
  end
end
