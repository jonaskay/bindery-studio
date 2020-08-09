require "rails_helper"

RSpec.describe Project::Message, type: :model do
  describe "#valid?" do
    subject { message.valid? }

    context "when params are valid" do
      let(:message) { build(:project_message) }

      it { is_expected.to be true  }
    end

    context "when project is nil" do
      let(:message) { build(:project_message, project: nil) }

      it { is_expected.to be false }
    end

    context "when name is blank" do
      let(:message) { build(:project_message, name: "   ") }

      it { is_expected.to be false }
    end

    context "when detail is blank" do
      let(:message) { build(:project_message, detail: "   ") }

      it { is_expected.to be false }
    end
  end
end
