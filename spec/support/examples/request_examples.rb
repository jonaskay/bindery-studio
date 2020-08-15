RSpec.shared_examples "failed authentication" do
  it "redirects to /users/sign_in" do
    subject

    expect(response).to redirect_to("/users/sign_in")
  end
end

RSpec.shared_examples "failed routing" do
  it "raises a routing error" do
    expect { subject }.to raise_error(ActionController::RoutingError)
  end
end
