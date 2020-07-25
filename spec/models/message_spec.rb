require 'rails_helper'

RSpec.describe Message, type: :model do
  describe "#valid?" do
    let(:message) { build(:message) }

    subject { message.valid? }

    it { is_expected.to be true }

    context "when publication is blank" do
      let(:message) { build(:message, publication: "   ") }

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
