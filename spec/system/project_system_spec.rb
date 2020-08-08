require "rails_helper"
require "support/googleapis"

RSpec.describe "Project management", type: :system, js: true do
  include Googleapis

  let(:user) { create(:user, :confirmed) }

  before do
    create(:project, user: user, title: "My Project", name: "my-project")
    create(:project, title: "Other Project")
    sign_in user
  end

  context "when listing project" do
    before do
      visit "/projects"
    end

    it "enables user to see own project" do
      expect(page).to have_link("My Project")
    end

    it "prevents user from seeing project from other users" do
      expect(page).not_to have_link("Other Project")
    end
  end

  context "when creating new project" do
    before do
      visit "/projects"

      click_link "Add Project"
    end

    it "enables user to create a project piece" do
      fill_in "Title", with: "My Title"
      fill_in "Project ID", with: "my-id"
      click_button "Create"

      expect(page).to have_text("Project created!")
    end

    it "prevents user from creating a project piece with invalid data" do
      fill_in "Title", with: "   "
      fill_in "Project ID", with: "   "

      click_button "Create"

      expect(page).to have_text("Oops! Could not create project.")
      expect(page).to have_text("Title can't be blank")
      expect(page).to have_text("Project ID can't be blank")
    end
  end

  context "when editing project" do
    before do
      visit "/projects"
    end

    it "enables user to edit a project piece" do
      click_link "My Project"

      expect(page).to have_field("Project ID", disabled: true)

      fill_in "Title", with: "Updated Title"
      click_button "Update"

      expect(page).to have_text("Project updated!")

      click_link "Projects"

      expect(page).to have_link("Updated Title")
    end

    it "prevents user from editing a project piece with invalid data" do
      click_link "My Project"

      fill_in "Title", with: "   "
      click_button "Update"

      expect(page).to have_text("Oops! Could not update project.")
      expect(page).to have_text("Title can't be blank")
    end
  end

  context "when deleting project" do
    before do
      handle_oauth_request

      stub(:compute, :insert_instance, params: {
        "project" => "my-project",
        "zone" => "my-zone",
        "template" => "my-unpublish-template"
      }).with_json('{ "id": "42" }')
    end

    it "enables user to delete a project piece" do
      visit "/projects"

      click_link "My Project"

      accept_confirm { click_link "Delete" }

      expect(page).to have_text("Project is being deleted. It will take a few minutes before all the published resources are deleted.")
      expect(page).to have_current_path("/projects")
      expect(page).not_to have_link("My Project")
    end
  end
end
