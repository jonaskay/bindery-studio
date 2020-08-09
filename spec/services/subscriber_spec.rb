require "rails_helper"

RSpec.shared_context "valid message" do
  let(:message) {
    {
      project: {
        id: "13371337-1337-1337-1337-133713371337",
        name: "foo"
      },
      status: "success",
      timestamp: "1970-01-01T00:00:00.000Z"
    }
  }
end

RSpec.shared_context "invalid message" do
  let(:message) {
    {
      project: {
        id: "invalid",
        name: "invalid"
      },
      status: "invalid",
      timestamp: "invalid"
    }
  }
end

RSpec.describe Subscriber, type: :model do
  let(:message_data) { Base64.encode64(message.to_json) }

  describe ".read_from_deploy" do
    subject { described_class.read_from_deploy(message_data) }

    context "when message is valid" do
      include_context "valid message"

      context "when project exists" do
        let!(:project) { create(:project, id: "13371337-1337-1337-1337-133713371337") }

        it "updates project to deployed" do
          expect { subject }.to change { project.reload.deployed? }.to(true)
        end
      end

      context "when project doesn't exist" do
        it "raises an error" do
          expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end

    context "when message is invalid" do
      include_context "invalid message"

      it "raises an error" do
        expect { subject }.to raise_error(ActiveModel::ValidationError)
      end
    end
  end

  describe ".read_from_cleanup" do
    subject { described_class.read_from_cleanup(message_data) }

    context "when message is valid" do
      include_context "valid message"

      context "when project exists" do
        let!(:project) { create(:project, :discarded, id: "13371337-1337-1337-1337-133713371337") }

        it "deletes project" do
          expect { subject }.to change { Project.count }.by(-1)
        end
      end

      context "when project doesn't exist" do
        it "raises an error" do
          expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end

    context "when message is invalid" do
      include_context "invalid message"

      it "raises an error" do
        expect { subject }.to raise_error(ActiveModel::ValidationError)
      end
    end
  end
end
