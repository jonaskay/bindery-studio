require 'rails_helper'
require 'support/googleapis'

RSpec.describe Publisher, type: :model do
  include Googleapis

  before do
    handle_oauth_request
    stub(:insert_instance, { "project" => "foo" }).with_json('{ "id": "42" }')
    stub(:insert_instance, { "project" => "invalid" }).with_json('{ "error": { "code": 404 } }', status: 404)
  end

  describe "#publish" do
    subject { publisher.publish }

    context "when project is valid" do
      let(:publisher) { Publisher.new(project: "foo", zone: "bar", instance_template: "baz") }

      it "returns site name" do
        expect(subject).to be_instance_of(String)
        expect(subject).to include("site-")
      end
    end

    context "when project is invalid" do
      let(:publisher) { Publisher.new(project: "invalid", zone: "bar", instance_template: "baz") }

      it "raises an error" do
        expect { subject }.to raise_error(Google::Apis::ClientError)
      end
    end
  end
end
