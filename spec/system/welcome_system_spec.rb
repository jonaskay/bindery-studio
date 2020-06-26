require "rails_helper"

RSpec.describe "Welcome", type: :system do
  before do
    user = create(:user, :confirmed, email: 'jane@example.com')
    sign_in(user)
  end

  it "displays a welcome message" do
    visit "/"

    expect(page).to have_text("Welcome jane@example.com!")
  end
end
