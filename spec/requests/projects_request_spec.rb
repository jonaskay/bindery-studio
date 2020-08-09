require 'rails_helper'
require 'support/examples/request_examples'

RSpec.describe "Projects", type: :request do
  describe "GET /projects" do
    subject { get "/projects" }

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
      include_examples "failed authentication"
    end
  end

  describe "GET /projects/new" do
    subject { get "/projects/new" }

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
      include_examples "failed authentication"
    end
  end

  describe "POST /projects" do
    subject { post "/projects", params: { project: { title: "foo", name: "foo" } } }

    context "when logged in" do
      before do
        user = create(:user, :confirmed)
        sign_in user
      end

      it "redirects to /projects/:name/edit" do
        subject

        expect(response).to redirect_to("/projects/foo/edit")
      end
    end

    context "when logged out" do
      include_examples "failed authentication"
    end
  end

  describe "GET /projects/:name/edit" do
    let(:user) { create(:user, :confirmed) }
    let(:other_user) { create(:user, :confirmed) }
    let(:project) { create(:project, user: user) }

    subject { get "/projects/#{project.name}/edit" }

    context "when logged in as valid user" do
      before do
        sign_in user
      end

      context "when project is undiscarded" do
        it "returns http success" do
          subject

          expect(response).to have_http_status(:success)
        end
      end

      context "when project is discarded" do
        before { project.discard }

        include_examples "failed routing"
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

  describe "PUT /projects/:name" do
    let(:user) { create(:user, :confirmed) }
    let(:other_user) { create(:user, :confirmed) }
    let(:project) { create(:project, user: user) }

    subject { put "/projects/#{project.name}", params: { project: { title: "foo" } } }

    context "when logged in as valid user" do
      before do
        sign_in user
      end

      context "when project is undiscarded" do
        it "redirects to /projects/:name/edit" do
          subject

          expect(response).to redirect_to("/projects/#{project.name}/edit")
        end
      end

      context "when project is discarded" do
        before { project.discard }

        include_examples "failed routing"
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

  describe "DELETE /projects/:name" do
    let(:user) { create(:user, :confirmed) }
    let(:other_user) { create(:user, :confirmed) }
    let(:project) { create(:project, user: user) }

    subject { delete "/projects/#{project.name}" }

    context "when logged in as valid user" do
      before do
        sign_in user
      end

      context "when project is undiscarded" do
        it "redirects to /projects" do
          subject

          expect(response).to redirect_to("/projects")
        end
      end

      context "when project is discarded" do
        before { project.discard }

        include_examples "failed routing"
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
