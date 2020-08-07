require 'rails_helper'

RSpec.describe Pubsub::Message, type: :model do
  describe ".from_encoded" do
    let(:data) {
      Base64.encode64({
        project: {
          id: "42",
          name: "foo"
        },
        status: "bar",
        timestamp: "baz"
      }.to_json)
    }

    subject { described_class.from_encoded(data) }

    it "returns a message object" do
      result = subject

      expect(result).to be_a(Pubsub::Message)
      expect(result.project).to be_a(Pubsub::Project)
      expect(result.status).to eq("bar")
      expect(result.timestamp).to eq("baz")
    end
  end

  describe "#valid?" do
    let(:project)   { { "id" => "42", "name" => "foo" } }
    let(:status)    { "success" }
    let(:timestamp) { "1970-01-01T00:00:00.000Z" }
    let(:payload)   { { "project" => project, "status" => status, "timestamp" => timestamp } }
    let(:message)   { Pubsub::Message.new(payload) }

    subject { message.valid? }

    context "when payload is valid" do
      it { is_expected.to be true }
    end

    context "when project is nil" do
      let(:project) { nil }

      it { is_expected.to be false }
    end

    context "when status is invalid" do
      let(:status) { "invalid" }

      it { is_expected.to be false }
    end

    context "when status is blank" do
      let(:status) { "   " }

      it { is_expected.to be false }
    end

    context "when timestamp is invalid" do
      let(:timestamp) { "invalid" }

      it { is_expected.to be false }
    end

    context "when timestamp is blank" do
      let(:timestamp) { "   " }

      it { is_expected.to be false }
    end
  end
end
