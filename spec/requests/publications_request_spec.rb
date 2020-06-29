require 'rails_helper'

RSpec.describe "Publications", type: :request do
  describe "GET /index" do
    context "when logged in" do
      before do
        user = create(:user, :confirmed)
        sign_in user
      end

      it "returns http success" do
        get "/content"

        expect(response).to have_http_status(:success)
      end
    end

    context "when logged out" do
      it "redirects to /users/sign_in" do
        get "/content"

        expect(response).to redirect_to("/users/sign_in")
      end
    end
  end

  describe "GET /new" do
    context "when logged in" do
      before do
        user = create(:user, :confirmed)
        sign_in user
      end

      it "returns http success" do
        get "/content/new"

        expect(response).to have_http_status(:success)
      end
    end

    context "when logged out" do
      it "redirects to /users/sign_in" do
        get "/content/new"

        expect(response).to redirect_to("/users/sign_in")
      end
    end
  end

  describe "POST /create" do
    context "when logged in" do
      before do
        user = create(:user, :confirmed)
        sign_in user
      end

      it "redirects to /content" do
        post "/content", params: { publication: { title: "foo" } }

        expect(response).to redirect_to("/content")
      end
    end

    context "when logged out" do
      it "redirects to /users/sign_in" do
        post "/content", params: { publication: { title: "foo" } }

        expect(response).to redirect_to("/users/sign_in")
      end
    end
  end

  describe "GET /edit" do
    let(:user) { create(:user, :confirmed) }
    let(:other_user) { create(:user, :confirmed) }
    let(:publication) { create(:publication, user: user) }

    context "when logged in as valid user" do
      before do
        sign_in user
      end

      it "returns http success" do
        get "/content/#{publication.id}/edit"

        expect(response).to have_http_status(:success)
      end
    end

    context "when logged in as wrong user" do
      before do
        sign_in other_user
      end

      it "raises a routing error" do
        expect { get "/content/#{publication.id}/edit" }.to raise_error(ActionController::RoutingError)
      end
    end

    context "when logged out" do
      it "redirects to /users/sign_in" do
        get "/content/#{publication.id}/edit"

        expect(response).to redirect_to("/users/sign_in")
      end
    end
  end

  describe "PUT /update" do
    let(:user) { create(:user, :confirmed) }
    let(:other_user) { create(:user, :confirmed) }
    let(:publication) { create(:publication, user: user) }

    context "when logged in as valid user" do
      before do
        sign_in user
      end

      it "redirects to /content/:id/edit" do
        put "/content/#{publication.id}", params: { publication: { title: "foo" } }

        expect(response).to redirect_to("/content/#{publication.id}/edit")
      end
    end

    context "when logged in as wrong user" do
      before do
        sign_in other_user
      end

      it "raises a routing error" do
        expect {
          put "/content/#{publication.id}", params: { publication: { title: "foo" } }
        }.to raise_error(ActionController::RoutingError)
      end
    end

    context "when logged out" do
      it "redirects to /users/sign_in" do
        put "/content/#{publication.id}", params: { publication: { title: "foo" } }

        expect(response).to redirect_to("/users/sign_in")
      end
    end
  end

  describe "DELETE /destroy" do
    let(:user) { create(:user, :confirmed) }
    let(:other_user) { create(:user, :confirmed) }
    let(:publication) { create(:publication, user: user) }

    context "when logged in as valid user" do
      before do
        sign_in user
      end

      it "redirects to /content" do
        delete "/content/#{publication.id}"

        expect(response).to redirect_to("/content")
      end
    end

    context "when logged in as wrong user" do
      before do
        sign_in other_user
      end

      it "raises a routing error" do
        expect {
          delete "/content/#{publication.id}"
        }.to raise_error(ActionController::RoutingError)
      end
    end

    context "when logged out" do
      it "redirects to /users/sign_in" do
        delete "/content/#{publication.id}"

        expect(response).to redirect_to("/users/sign_in")
      end
    end
  end
end
