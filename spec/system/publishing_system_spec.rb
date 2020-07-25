require "rails_helper"
require "support/googleapis"

RSpec.describe "Content publishing", type: :system do
  include Googleapis

  let(:user) { create(:user, :confirmed) }
  let(:publication) { create(:publication, user: user, title: "My Publication") }

  before do
    handle_oauth_request
    stub(:insert_instance).with_json('{ "id": "42" }')

    sign_in user
  end

  it "enables user to publish content" do
    visit "/content/#{publication.id}/edit"

    click_link "Publish"

    expect(page).to have_text("Content is being published. This process will take a few minutes.")
    expect(page).not_to have_link("Visit site")
    expect(page).not_to have_link("Publish")

    publication.update_attribute(:deployed_at, Time.current)

    visit "/content/#{publication.id}/edit"

    expect(page).to have_link("Visit site")
  end
end
