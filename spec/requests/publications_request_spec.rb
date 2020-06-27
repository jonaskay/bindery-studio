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
      it "returns http redirect" do
        get "/content"

        expect(response).to have_http_status(:redirect)
      end
    end
  end

  describe "GET /show" do
    let(:user) { create(:user, :confirmed) }
    let(:other_user) { create(:user, :confirmed) }
    let(:publication) { create(:publication, user: user) }

    context "when logged in as valid user" do
      before do
        sign_in user
      end

      it "returns http success" do
        get "/content/#{publication.id}"

        expect(response).to have_http_status(:success)
      end
    end

    context "when logged in as wrong user" do
      before do
        sign_in other_user
      end

      it "returns http not found" do
        expect { get "/content/#{publication.id}" }.to raise_error(ActionController::RoutingError)
      end
    end

    context "when logged out" do
      it "returns http redirect" do
        get "/content/#{publication.id}"

        expect(response).to have_http_status(:redirect)
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
      it "returns http redirect" do
        get "/content/new"

        expect(response).to have_http_status(:redirect)
      end
    end
  end

  describe "POST /create" do
    context "when logged in" do
      before do
        user = create(:user, :confirmed)
        sign_in user
      end

      it "returns http redirect" do
        post "/content", params: { publication: { title: "foo" } }

        expect(response).to have_http_status(:redirect)
      end
    end

    context "when logged out" do
      it "returns http redirect" do
        post "/content", params: { publication: { title: "foo" } }

        expect(response).to have_http_status(:redirect)
      end
    end
  end
end
