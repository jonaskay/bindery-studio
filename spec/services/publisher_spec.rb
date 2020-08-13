require "rails_helper"
require "support/helpers/googleapis_helper"

RSpec.shared_examples "successful insert instance request" do
  it "sends an insert instance request" do
    subject

    expect(insert_instance_stub).to have_been_requested
  end
end

RSpec.describe Publisher, type: :model do
  include GoogleapisHelper

  let(:project) { create(:project) }
  let!(:insert_instance_stub) {
    stub(:compute, :insert_instance, params: {
      "project" => "my-project",
      "zone" => "my-zone",
      "template" => "my-compositor-template"
    }).with_json('{ "id": "42" }')
  }

  before { handle_oauth_request }

  describe ".publish" do
    subject { described_class.publish(project) }

    include_examples "successful insert instance request"

    it "creates a new deployment" do
      expect { subject }.to change { project.deployments.count }.by(1)
    end
  end

  describe "#insert_instance" do
    let(:publisher) { Publisher.new(project) }

    subject { publisher.insert_instance("foo") }

    include_examples "successful insert instance request"

    it "returns an operation object" do
      expect(subject).to be_a(Google::Apis::ComputeV1::Operation)
    end
  end
end
