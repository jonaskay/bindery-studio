require 'rails_helper'
require 'support/googleapis'

RSpec.describe "Publishings", type: :request do
  include Googleapis

  before do
    handle_oauth_request

    stub(:compute, :insert_instance, params: {
      "project" => "my-project",
      "zone" => "my-zone",
      "template" => "my-publish-template"
    }).with_json('{ "id": "42" }')
  end

  describe "POST /projects/:project_name/publish" do
    let(:user) { create(:user, :confirmed) }
    let(:other_user) { create(:user, :confirmed) }
    let(:project) { create(:project, user: user) }

    context "when logged in as valid user" do
      before do
        sign_in user
      end

      context "when project is unpublished" do
        it "redirects to /projects/:name/edit with notice" do
          post "/projects/#{project.name}/publish"

          expect(response).to redirect_to("/projects/#{project.name}/edit")
          expect(flash[:notice]).not_to be_empty
        end
      end

      context "when project is published" do
        let(:project) { create(:project, :published, user: user) }

        it "redirects to /projects/:name/edit with alert" do
          post "/projects/#{project.name}/publish"

          expect(response).to redirect_to("/projects/#{project.name}/edit")
          expect(flash[:alert]).not_to be_empty
        end
      end
    end

    context "when logged in as wrong user" do
      before do
        sign_in other_user
      end

      it "raises a routing error" do
        expect {
          post "/projects/#{project.name}/publish"
        }.to raise_error(ActionController::RoutingError)
      end
    end

    context "when logged out" do
      it "redirects to /users/sign_in" do
        post "/projects/#{project.name}/publish"

        expect(response).to redirect_to("/users/sign_in")
      end
    end
  end
end
