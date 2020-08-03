require "rails_helper"

RSpec.shared_context "valid message", shared_context: :metadata do
  let(:message) {
    {
      publicationId: 42,
      status: "success",
      timestamp: "1970-01-01T00:00:00.000Z"
    }
  }
end

RSpec.shared_context "invalid message", shared_context: :metadata do
  let(:message) {
    {
      publicationId: "invalid",
      status: "invalid",
      timestamp: "invalid"
    }
  }
end

RSpec.describe Subscriber, type: :model do
  let(:message_data) { Base64.encode64(message.to_json) }

  describe ".read_from_publish" do
    subject { described_class.read_from_publish(message_data) }

    context "when message is valid" do
      include_context "valid message", include_shared: true

      context "when publication exists" do
        let!(:publication) { create(:publication, :published, id: 42) }

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
      include_context "invalid message", include_shared: true

      it "raises an error" do
        expect { subject }.to raise_error(ActiveModel::ValidationError)
      end
    end
  end

  describe ".read_from_unpublish" do
    subject { described_class.read_from_unpublish(message_data) }

    context "when message is valid" do
      include_context "valid message", include_shared: true

      context "when publication exists" do
        let!(:publication) { create(:publication, :discarded, id: 42) }

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
      include_context "invalid message", include_shared: true

      it "raises an error" do
        expect { subject }.to raise_error(ActiveModel::ValidationError)
      end
    end
  end
end
