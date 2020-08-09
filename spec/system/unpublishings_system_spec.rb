require "rails_helper"
require "support/googleapis"

RSpec.describe "Project unpublishing", type: :system, js: true do
  include Googleapis

  let(:user) { create(:user, :confirmed) }
  let(:project_row) { "tr#project_#{project.id}" }
  let!(:project) { create(:project, :published, user: user, title: "My Project", name: "my-project") }

  before do
    cleaner = class_double("Cleaner").as_stubbed_const
    allow(cleaner).to receive(:clean).and_return(true)

    handle_oauth_request

    sign_in user
  end

  it "enables user to delete a project" do
    visit "/projects"

    within(project_row) do
      expect(page).to have_link("My Project")
      expect(page).to have_text("Published")
    end

    click_link "My Project"

    accept_confirm { click_link "Delete" }

    expect(page).to have_text("Project is being deleted. It will take a few minutes before all the published resources are deleted.")
    expect(page).to have_current_path("/projects")

    within(project_row) do
      expect(page).to have_text("My Project")
      expect(page).to have_text("Deleting")
      expect(page).not_to have_link("My Project")
    end
  end
end
