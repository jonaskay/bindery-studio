require "rails_helper"

RSpec.describe "Content management", type: :system do
  let(:user) { create(:user, :confirmed) }

  before do
    sign_in user
  end

  context "when listing content" do
    before do
      create(:publication, user: user, title: "My Book")
      create(:publication, title: "Other Book")

      visit "/content"
    end

    it "enables user to see own content" do
      expect(page).to have_link("My Book")
    end

    it "prevents user from seeing content from other users" do
      expect(page).not_to have_link("Other Book")
    end
  end

  context "when creating new content" do
    before do
      visit "/content"

      click_link "Add Content"
    end

    it "enables user to create a content piece" do
      fill_in "Title", with: "My Book"
      click_button "Create"

      expect(page).to have_text("Content created!")
    end

    it "prevents user from creating a content piece without title" do
      fill_in "Title", with: ""
      click_button "Create"

      expect(page).to have_text("Oops! Could not create content.")
      expect(page).to have_text("Title can't be blank")
    end
  end
end
