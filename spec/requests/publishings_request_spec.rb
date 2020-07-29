require 'rails_helper'
require 'support/googleapis'

RSpec.describe "Publishings", type: :request do
  include Googleapis

  before do
    handle_oauth_request

    stub(:compute, :insert_instance, params: {
      "project" => "my-project",
      "zone" => "my-zone",
      "template" => "my-instance-template"
    }).with_json('{ "id": "42" }')
  end

  describe "POST /content/:publication_id/publish" do
    let(:user) { create(:user, :confirmed) }
    let(:other_user) { create(:user, :confirmed) }
    let(:publication) { create(:publication, user: user) }

    context "when logged in as valid user" do
      before do
        sign_in user
      end

      context "when publication is unpublished" do
        it "redirects to /content/:id/edit with notice" do
          post "/content/#{publication.id}/publish"

          expect(response).to redirect_to("/content/#{publication.id}/edit")
          expect(flash[:notice]).not_to be_empty
        end
      end

      context "when publication is published" do
        let(:publication) { create(:publication, :published, user: user) }

        it "redirects to /content/:id/edit with alert" do
          post "/content/#{publication.id}/publish"

          expect(response).to redirect_to("/content/#{publication.id}/edit")
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
          post "/content/#{publication.id}/publish"
        }.to raise_error(ActionController::RoutingError)
      end
    end

    context "when logged out" do
      it "redirects to /users/sign_in" do
        post "/content/#{publication.id}/publish"

        expect(response).to redirect_to("/users/sign_in")
      end
    end
  end
end
