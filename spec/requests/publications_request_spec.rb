require 'rails_helper'

RSpec.describe "Publications", type: :request do
  describe "GET /content" do
    subject { get "/content" }

    context "when logged in" do
      before do
        user = create(:user, :confirmed)
        sign_in user
      end

      it "returns http success" do
        subject

        expect(response).to have_http_status(:success)
      end
    end

    context "when logged out" do
      it "redirects to /users/sign_in" do
        subject

        expect(response).to redirect_to("/users/sign_in")
      end
    end
  end

  describe "GET /content/new" do
    subject { get "/content/new" }

    context "when logged in" do
      before do
        user = create(:user, :confirmed)
        sign_in user
      end

      it "returns http success" do
        subject

        expect(response).to have_http_status(:success)
      end
    end

    context "when logged out" do
      it "redirects to /users/sign_in" do
        subject

        expect(response).to redirect_to("/users/sign_in")
      end
    end
  end

  describe "POST /content" do
    subject { post "/content", params: { publication: { title: "foo", name: "foo" } } }

    context "when logged in" do
      before do
        user = create(:user, :confirmed)
        sign_in user
      end

      it "redirects to /content/:name/edit" do
        subject

        expect(response).to redirect_to("/content/foo/edit")
      end
    end

    context "when logged out" do
      it "redirects to /users/sign_in" do
        subject

        expect(response).to redirect_to("/users/sign_in")
      end
    end
  end

  describe "GET /content/:name/edit" do
    let(:user) { create(:user, :confirmed) }
    let(:other_user) { create(:user, :confirmed) }
    let(:publication) { create(:publication, user: user) }

    subject { get "/content/#{publication.name}/edit" }

    context "when logged in as valid user" do
      before do
        sign_in user
      end

      it "returns http success" do
        subject

        expect(response).to have_http_status(:success)
      end
    end

    context "when logged in as wrong user" do
      before do
        sign_in other_user
      end

      it "raises a routing error" do
        expect { subject }.to raise_error(ActionController::RoutingError)
      end
    end

    context "when logged out" do
      it "redirects to /users/sign_in" do
        subject

        expect(response).to redirect_to("/users/sign_in")
      end
    end
  end

  describe "PUT /content/:name" do
    let(:user) { create(:user, :confirmed) }
    let(:other_user) { create(:user, :confirmed) }
    let(:publication) { create(:publication, user: user) }

    subject { put "/content/#{publication.name}", params: { publication: { title: "foo" } } }

    context "when logged in as valid user" do
      before do
        sign_in user
      end

      it "redirects to /content/:name/edit" do
        subject

        expect(response).to redirect_to("/content/#{publication.name}/edit")
      end
    end

    context "when logged in as wrong user" do
      before do
        sign_in other_user
      end

      it "raises a routing error" do
        expect { subject }.to raise_error(ActionController::RoutingError)
      end
    end

    context "when logged out" do
      it "redirects to /users/sign_in" do
        subject

        expect(response).to redirect_to("/users/sign_in")
      end
    end
  end

  describe "DELETE /content/:name" do
    let(:user) { create(:user, :confirmed) }
    let(:other_user) { create(:user, :confirmed) }
    let(:publication) { create(:publication, user: user) }

    subject { delete "/content/#{publication.name}" }

    context "when logged in as valid user" do
      before do
        sign_in user
      end

      it "redirects to /content" do
        subject

        expect(response).to redirect_to("/content")
      end
    end

    context "when logged in as wrong user" do
      before do
        sign_in other_user
      end

      it "raises a routing error" do
        expect { subject }.to raise_error(ActionController::RoutingError)
      end
    end

    context "when logged out" do
      it "redirects to /users/sign_in" do
        subject

        expect(response).to redirect_to("/users/sign_in")
      end
    end
  end
end
