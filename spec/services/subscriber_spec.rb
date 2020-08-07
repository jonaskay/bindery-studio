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

      context "when publication exists" do
        let!(:publication) { create(:publication, :published, id: "13371337-1337-1337-1337-133713371337") }

        it "updates publication to deployed" do
          expect { subject }.to change { publication.reload.deployed? }.to(true)
        end
      end

      context "when publication doesn't exist" do
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

      context "when publication exists" do
        let!(:publication) { create(:publication, :discarded, id: "13371337-1337-1337-1337-133713371337") }

        it "deletes publication" do
          expect { subject }.to change { Publication.count }.by(-1)
        end
      end

      context "when publication doesn't exist" do
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
