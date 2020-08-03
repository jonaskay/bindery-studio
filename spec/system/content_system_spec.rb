require "rails_helper"
require "support/googleapis"

RSpec.describe "Content management", type: :system, js: true do
  include Googleapis

  let(:user) { create(:user, :confirmed) }

  before do
    create(:publication, user: user, title: "My Publication", name: "my-publication")
    create(:publication, title: "Other Publication")
    sign_in user
  end

  context "when listing content" do
    before do
      visit "/content"
    end

    it "enables user to see own content" do
      expect(page).to have_link("My Publication")
    end

    it "prevents user from seeing content from other users" do
      expect(page).not_to have_link("Other Publication")
    end
  end

  context "when creating new content" do
    before do
      visit "/content"

      click_link "Add Content"
    end

    it "enables user to create a content piece" do
      fill_in "Title", with: "My Title"
      fill_in "Content ID", with: "my-id"
      click_button "Create"

      expect(page).to have_text("Content created!")
    end

    it "prevents user from creating a content piece with invalid data" do
      fill_in "Title", with: "   "
      fill_in "Content ID", with: "   "

      click_button "Create"

      expect(page).to have_text("Oops! Could not create content.")
      expect(page).to have_text("Title can't be blank")
      expect(page).to have_text("Content ID can't be blank")
    end
  end

  context "when editing content" do
    before do
      visit "/content"
    end

    it "enables user to edit a content piece" do
      click_link "My Publication"

      expect(page).to have_field("Content ID", disabled: true)

      fill_in "Title", with: "Updated Title"
      click_button "Update"

      expect(page).to have_text("Content updated!")

      click_link "Content"

      expect(page).to have_link("Updated Title")
    end

    it "prevents user from editing a content piece with invalid data" do
      click_link "My Publication"

      fill_in "Title", with: "   "
      click_button "Update"

      expect(page).to have_text("Oops! Could not update content.")
      expect(page).to have_text("Title can't be blank")
    end
  end

  context "when deleting content" do
    before do
      handle_oauth_request

      stub(:compute, :insert_instance, params: {
        "project" => "my-project",
        "zone" => "my-zone",
        "template" => "my-unpublish-template"
      }).with_json('{ "id": "42" }')
    end

    it "enables user to delete a content piece" do
      visit "/content"

      click_link "My Publication"

      accept_confirm { click_link "Delete" }

      expect(page).to have_text("Content is being deleted. It will take a few minutes before all the published resources are deleted.")
      expect(page).to have_current_path("/content")
      expect(page).not_to have_link("My Publication")
    end
  end
end
