require "rails_helper"
require "support/googleapis"

RSpec.describe "Content publishing", type: :system do
  include Googleapis

  let(:user) { create(:user, :confirmed) }
  let!(:publication) { create(:publication, user: user, title: "My Publication", name: "my-publication") }

  before do
    handle_oauth_request
    stub(:compute, :insert_instance, params: {
      "project" => "my-project",
      "zone" => "my-zone",
      "template" => "my-instance-template"
    }).with_json('{ "id": "42" }')

    sign_in user
  end

  it "enables user to publish content" do
    visit "/content/my-publication/edit"

    click_link "Publish"

    expect(page).to have_text("Content is being published. This process will take a few minutes.")
    expect(page).not_to have_link("Visit site")
    expect(page).not_to have_link("Publish")

    publication.update_attribute(:deployed_at, Time.current)

    visit "/content/my-publication/edit"

    expect(page).to have_link("Visit site")
  end
end
