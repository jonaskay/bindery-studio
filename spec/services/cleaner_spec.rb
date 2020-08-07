require "rails_helper"
require "support/googleapis"

RSpec.describe Cleaner, type: :model do
  include Googleapis

  describe ".clean" do
    let(:message) { instance_double("Google::Cloud::PubSub::Message") }
    let(:topic) { instance_double("Google::Cloud::PubSub::Topic") }
    let(:pubsub) { instance_double("Google::Cloud::PubSub::Client") }
    let(:publication) { create(:publication, name: "foo") }

    subject { described_class.clean(publication, pubsub) }

    before do
      allow(pubsub).to receive(:topic).with("my-cleaner-topic").and_return(topic)
      allow(topic).to receive(:publish).with("{\"project\":{\"id\":\"#{publication.id}\",\"name\":\"foo\"}}").and_return(message)
    end

    it { is_expected.to eq(message) }
  end
end
