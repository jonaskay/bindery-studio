require 'rails_helper'
require 'support/googleapis'

RSpec.describe Publisher, type: :model do
  include Googleapis

  describe ".publish" do
    before do
      handle_oauth_request

      stub(:compute, :insert_instance, params: {
        "project" => "foo",
        "zone" => "bar",
        "template" => "baz"
      }).with_json('{ "id": "42" }')

      stub(:compute, :insert_instance, params: {
        "project" => "invalid",
        "zone" => "bar",
        "template" => "baz"
      }).with_json('{ "error": { "code": 404 } }', status: 404)
    end

    let(:publication) { create(:publication) }

    subject { described_class.publish(publication, project: project, zone: "bar", template: "baz") }

    context "when project is valid" do
      let(:project) { "foo" }

      it { is_expected.to be_instance_of(Google::Apis::ComputeV1::Operation) }
    end

    context "when project is invalid" do
      let(:project) { "invalid" }

      it "raises an error" do
        expect { subject }.to raise_error(Google::Apis::ClientError)
      end
    end
  end

  describe ".unpublish" do
    before do
      handle_oauth_request

      stub(:storage, :delete_bucket, params: { "bucket" => "foo" }).with_status(204)
    end

    let(:publication) { create(:publication, name: "foo") }

    subject { described_class.unpublish(publication) }

    it { is_expected.to eq "" }
  end

  describe ".read" do
    let(:publication) { create(:publication, name: "foo") }

    subject do
      encoded_message = Base64.encode64(message.to_json)

      described_class.read(encoded_message)
    end

    context "when message is valid" do
      let(:message) {
        {
          publication: "foo",
          status: "success",
          timestamp: "1970-01-01T00:00:00.000Z"
        }
      }

      it "updates publication to deployed" do
        expect { subject }.to change { publication.reload.deployed_at.to_s }.to("1970-01-01 00:00:00 UTC")
      end
    end

    context "when message is invalid" do
      let(:message) {
        {
          publication: "   ",
          status: "invalid",
          timestamp: "invalid"
        }
      }

      it "raises an error" do
        expect { subject }.to raise_error(Publisher::Error, "Invalid message: Publication can't be blank")
      end
    end

    context "when message publication doesn't exist" do
      let(:message) {
        {
          publication: "bar",
          status: "success",
          timestamp: "1970-01-01T00:00:00.000Z"
        }
      }

      it "raises an error" do
        expect { subject }.to raise_error(Publisher::Error, "Couldn't find publication")
      end
    end
  end
end
