require 'rails_helper'

RSpec.shared_examples "valid message object" do
  it "returns a message object" do
    expect(subject).to be_a(Pubsub::Message)
  end

  describe "#project" do
    it "returns a project object" do
      expect(subject.project).to be_a(Pubsub::Project)
    end
  end
end

RSpec.shared_examples "empty error data" do
  describe "#error_data" do
    it "returns nil" do
      expect(subject.error_data).to be_empty
    end
  end
end

RSpec.describe Pubsub::Message, type: :model do
  describe ".from_encoded" do
    let(:data) {
      Base64.encode64({
        project: {
          id: "42",
          name: "foo"
        },
        errors: errors,
        timestamp: "baz"
      }.to_json)
    }

    subject { described_class.from_encoded(data) }

    context "when errors field is nil" do
      let(:errors) { nil }

      include_examples "valid message object"
      include_examples "empty error data"
    end

    context "when errors field is not nil" do
      context "when errors field is empty" do
        let(:errors) { [] }

        include_examples "valid message object"
        include_examples "empty error data"
      end

      context "when errors field is not empty" do
        let(:errors) { [{ name: "foo", message: "bar" }, { name: "baz", message: "qux" }] }

        include_examples "valid message object"

        describe "#error_data" do
          it "returns error objects" do
            expect(subject.error_data[0]).to be_a(Pubsub::ErrorItem)
            expect(subject.error_data[1]).to be_a(Pubsub::ErrorItem)
          end
        end
      end
    end
  end

  describe "#valid?" do
    let(:project)   { { "id" => "42", "name" => "foo" } }
    let(:timestamp) { "1970-01-01T00:00:00.000Z" }
    let(:payload)   { { "project" => project, "timestamp" => timestamp } }
    let(:message)   { Pubsub::Message.new(payload) }

    subject { message.valid? }

    context "when payload is valid" do
      it { is_expected.to be true }
    end

    context "when project is nil" do
      let(:project) { nil }

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
