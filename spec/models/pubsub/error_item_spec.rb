require "rails_helper"

RSpec.describe Pubsub::ErrorItem, type: :model do
  describe "#valid?" do
    let(:name)    { "foo" }
    let(:message) { "bar" }
    let(:payload) { { "name" => name, "message" => message } }
    let(:error)   { Pubsub::ErrorItem.new(payload) }

    subject { error.valid? }

    context "when payload is valid" do
      it { is_expected.to be true }
    end

    context "when name is blank" do
      let(:name) { "   " }

      it { is_expected.to be false }
    end

    context "when message is blank" do
      let(:message) { "   " }

      it { is_expected.to be false }
    end
  end
end
