require 'rails_helper'
require 'support/googleapis'
require 'support/examples/request_examples'

RSpec.describe "Publishings", type: :request do
  include Googleapis

  before do
    handle_oauth_request

    stub(:compute, :insert_instance, params: {
      "project" => "my-project",
      "zone" => "my-zone",
      "template" => "my-compositor-template"
    }).with_json('{ "id": "42" }')
  end

  describe "POST /projects/:project_name/publish" do
    let(:user) { create(:user, :confirmed) }
    let(:other_user) { create(:user, :confirmed) }
    let(:project) { create(:project, user: user) }

    subject { post "/projects/#{project.name}/publish" }

    context "when logged in as valid user" do
      before do
        sign_in user
      end

      context "when project is hidden" do
        it "redirects to /projects/:name/edit with notice" do
          subject

          expect(response).to redirect_to("/projects/#{project.name}/edit")
          expect(flash[:notice]).not_to be_empty
        end
      end

      context "when project is released" do
        let(:project) { create(:project, :released, user: user) }

        it "redirects to /projects/:name/edit with alert" do
          subject

          expect(response).to redirect_to("/projects/#{project.name}/edit")
          expect(flash[:alert]).not_to be_empty
        end
      end
    end

    context "when logged in as wrong user" do
      before do
        sign_in other_user
      end

      include_examples "failed routing"
    end

    context "when logged out" do
      include_examples "failed authentication"
    end
  end
end
