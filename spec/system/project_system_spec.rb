require "rails_helper"
require "support/helpers/googleapis_helper"

RSpec.describe "Project management", type: :system do
  include GoogleapisHelper

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

    it "enables user to create a project" do
      fill_in "Title", with: "My Title"
      fill_in "Project ID", with: "my-id"
      click_button "Create"

      expect(page).to have_text("Project created!")
    end

    it "prevents user from creating a project with invalid data" do
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

    it "enables user to edit a project" do
      click_link "My Project"

      expect(page).to have_field("Project ID", disabled: true)

      fill_in "Title", with: "Updated Title"
      click_button "Update"

      expect(page).to have_text("Project updated!")

      click_link "Projects"

      expect(page).to have_link("Updated Title")
    end

    it "prevents user from editing a project with invalid data" do
      click_link "My Project"

      fill_in "Title", with: "   "
      click_button "Update"

      expect(page).to have_text("Oops! Could not update project.")
      expect(page).to have_text("Title can't be blank")
    end
  end
end
