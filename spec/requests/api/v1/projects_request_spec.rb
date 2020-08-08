require 'rails_helper'

RSpec.describe "Api::V1::Projects", type: :request do
  describe "GET /api/v1/projects/:id" do
    before { get "/api/v1/projects/#{project.id}" }

    describe "response" do
      subject { response }

      context "when project is published" do
        let(:project) { create(:project, :published, name: "foo", title: "bar") }

        it { is_expected.to have_http_status(:success) }

        describe "body" do
          subject { response.body }

          it { is_expected.to eq(
            {
              data: {
                id: project.id.to_s,
                type: "project",
                attributes: {
                  name: "foo",
                  title: "bar"
                }
              }
            }.to_json
          ) }
        end
      end

      context "when project is not published" do
        let(:project) { create(:project) }

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
