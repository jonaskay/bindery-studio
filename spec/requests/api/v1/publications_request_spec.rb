require 'rails_helper'

RSpec.describe "Api::V1::Publications", type: :request do
  describe "GET /api/v1/publications/:id" do
    before { get "/api/v1/publications/#{publication.id}" }

    describe "response" do
      subject { response }

      context "when publication is published" do
        let(:publication) { create(:publication, :published, name: "foo", title: "bar") }

        it { is_expected.to have_http_status(:success) }

        describe "body" do
          subject { response.body }

          it { is_expected.to eq(
            {
              data: {
                id: publication.id.to_s,
                type: "publication",
                attributes: {
                  name: "foo",
                  title: "bar"
                }
              }
            }.to_json
          ) }
        end
      end

      context "when publication is not published" do
        let(:publication) { create(:publication) }

        it { is_expected.to have_http_status(:not_found) }

        describe "body" do
          subject { response.body }

          it { is_expected.to eq(
            {
              errors: [
                {
                  status: "404",
                  title: "Not Found"
                }
              ]
            }.to_json
          ) }
        end
      end
    end
  end
end
