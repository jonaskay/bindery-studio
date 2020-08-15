require "rails_helper"
require "support/helpers/googleapis_helper"

RSpec.describe ComputeEngine, type: :model do
  include GoogleapisHelper

  before { handle_oauth_request }

  describe "#delete_instance" do
    let!(:delete_instance_stub) {
      stub(:compute, :delete_instance, params: {
        "project" => "my-project",
        "zone" => "my-zone",
        "instance" => "foo"
      }).with_json('{ "id": "42" }')
    }

    subject { described_class.new.delete_instance("foo") }

    it "sends a delete instance request" do
      subject

      expect(delete_instance_stub).to have_been_requested
    end

    it "returns an operation object" do
      expect(subject).to be_a(Google::Apis::ComputeV1::Operation)
    end
  end

  describe "#insert_instance" do
    let!(:insert_instance_stub) {
      stub(:compute, :insert_instance, params: {
        "project" => "my-project",
        "zone" => "my-zone",
        "template" => "bar"
      }).with_json('{ "id": "42" }')
    }

    subject { described_class.new.insert_instance("foo", "bar") }

    it "sends an insert instance request" do
      subject

      expect(insert_instance_stub).to have_been_requested
    end

    it "returns an operation object" do
      expect(subject).to be_a(Google::Apis::ComputeV1::Operation)
    end
  end
end
