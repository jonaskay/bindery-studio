require 'rails_helper'

RSpec.describe "Api::V1::Publications", type: :request do
  describe "GET /api/v1/publications/:name" do
    before do
      create(:site, publication: publication)

      get "/api/v1/publications/#{publication.name}"
    end

    context "when publication is published" do
      let(:publication) { create(:publication, :published) }

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "returns a publication object" do
        expect(response.body).to eq(
          {
            data: {
              id: publication.id.to_s,
              type: "publication",
              attributes: {
                title: "title"
              }
            }
          }.to_json
        )
      end
    end

    context "when publication is not published" do
      let(:publication) { create(:publication) }

      it "returns http not found" do
        expect(response).to have_http_status(:not_found)
      end

      it "returns an error object" do
        expect(response.body).to eq(
          {
            errors: [
              {
                status: "404",
                title: "Not Found"
              }
            ]
          }.to_json
        )
      end
    end
  end
end
