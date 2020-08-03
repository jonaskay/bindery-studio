require 'rails_helper'

RSpec.describe Message, type: :model do
  describe ".from_encoded" do
    let(:data) {
      Base64.encode64({
        publicationId: "foo",
        status: "bar",
        timestamp: "baz"
      }.to_json)
    }

    subject { described_class.from_encoded(data) }

    it "returns a message object" do
      result = subject

      expect(result).to be_a(Message)
      expect(result.publication_id).to eq("foo")
      expect(result.status).to eq("bar")
      expect(result.timestamp).to eq("baz")
    end
  end

  describe "#valid?" do
    let(:message) { build(:message) }

    subject { message.valid? }

    it { is_expected.to be true }

    context "when publication is blank" do
      let(:message) { build(:message, publication_id: "   ") }

      it { is_expected.to be false }
    end

    context "when status is invalid" do
      let(:message) { build(:message, status: "invalid") }

      it { is_expected.to be false }
    end

    context "when status is blank" do
      let(:message) { build(:message, status: "   ") }

      it { is_expected.to be false }
    end

    context "when timestamp is invalid" do
      let(:message) { build(:message, timestamp: "invalid") }

      it { is_expected.to be false }
    end

    context "when timestamp is blank" do
      let(:message) { build(:message, timestamp: "   ") }

      it { is_expected.to be false }
    end
  end
end
