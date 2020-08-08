require "rails_helper"
require "support/googleapis"

RSpec.describe "Project publishing", type: :system do
  include Googleapis

  let(:user) { create(:user, :confirmed) }
  let!(:project) { create(:project, user: user, name: "my-project") }

  before do
    handle_oauth_request
    stub(:compute, :insert_instance, params: {
      "project" => "my-project",
      "zone" => "my-zone",
      "template" => "my-compositor-template"
    }).with_json('{ "id": "42" }')

    sign_in user
  end

  it "enables user to publish project" do
    visit "/projects/my-project/edit"

    click_link "Publish"

    expect(page).to have_text("Project is being published. This process will take a few minutes.")
    expect(page).not_to have_link("Visit site")
    expect(page).not_to have_link("Publish")

    project.update_attribute(:deployed_at, Time.current)

    visit "/projects/my-project/edit"

    expect(page).to have_link("Visit site")
  end
end
