require "rails_helper"
require "support/helpers/googleapis_helper"
require "support/helpers/selector_helper"

RSpec.describe "Project publishing", type: :system do
  include GoogleapisHelper
  include SelectorHelper

  let(:user) { create(:user, :confirmed) }

  before do
    handle_oauth_request
    stub(:compute, :insert_instance, params: {
      "project" => "my-project",
      "zone" => "my-zone",
      "template" => "my-compositor-template"
    }).with_json('{ "id": "42" }')

    sign_in user
  end

  context "when project is unpublished" do
    let!(:project) { create(:project, user: user, name: "my-project", title: "My Project") }

    it "enables user to publish the project" do
      visit "/projects"

      within(project_row(project)) do
        expect(page).to have_text("Unpublished")

        click_link "My Project"
      end

      click_link "Publish"

      expect(page).to have_text("Project is being published. This process will take a few minutes.")
      expect(page).not_to have_link("Visit site")
      expect(page).not_to have_link("Publish")

      project.current_deployment.update_attribute(:finished_at, Time.current)

      visit "/projects/my-project/edit"

      expect(page).to have_link("Visit site")
    end
  end

  context "when project publishing has failed" do
    let(:project) { create(:project, :released, user: user, name: "my-project", title: "My Project") }

    before { create(:deployment, :failed, project: project) }

    it "enables user to republish the project" do
      visit "/projects"

      within(project_row(project)) do
        expect(page).to have_text("Error")

        click_link "My Project"
      end

      expect(page).to have_text("Publishing the project failed. Click Publish to try again.")

      click_link "Publish"

      expect(page).to have_text("Project is being published. This process will take a few minutes.")
      expect(page).not_to have_text("Publishing the project failed. Click Publish to try again.")
    end
  end
end
