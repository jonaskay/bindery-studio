require "rails_helper"

RSpec.describe "Content management", type: :system, js: true do
  let(:user) { create(:user, :confirmed) }

  before do
    create(:publication, user: user, title: "My Publication")
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
      click_button "Create"

      expect(page).to have_text("Content created!")
    end

    it "prevents user from creating a content piece without title" do
      fill_in "Title", with: "   "
      click_button "Create"

      expect(page).to have_text("Oops! Could not create content.")
      expect(page).to have_text("Title can't be blank")
    end
  end

  context "when editing content" do
    before do
      visit "/content"
    end

    it "enables user to edit a content piece" do
      click_link "My Publication"

      fill_in "Title", with: "   "
      click_button "Update"

      expect(page).to have_text("Oops! Could not update content.")
      expect(page).to have_text("Title can't be blank")

      fill_in "Title", with: "Updated Title"
      click_button "Update"

      expect(page).to have_text("Content updated!")

      click_link "Content"

      expect(page).to have_link("Updated Title")
    end

    it "enables user to delete a content piece" do
      click_link "My Publication"

      accept_confirm { click_link "Delete" }

      expect(page).to have_text("Content deleted.")
      expect(page).to have_current_path("/content")
      expect(page).not_to have_link("My Publication")
    end
  end
end
