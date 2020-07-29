require "rails_helper"
require "support/googleapis"

RSpec.describe StorageCleanupJob, type: :job do
  include Googleapis

  describe "#perform" do
    before do
      handle_oauth_request

      stub(:storage, :list_objects, params: { "bucket" => "42", "prefix" => "foo" })
        .with_json(
          {
            items: [
              {
                bucket: "42",
                name: "foo/bar"
              },
              {
                bucket: "42",
                name: "foo/baz/qux"
              }
            ]
          }.to_json
        )
    end

    let(:job) { described_class.new }

    subject { job.perform("42", "foo") }

    it "deletes each object from a folder" do
      delete_stubs = [
        stub(:storage, :delete_object, params: { "bucket" => "42", "object" => "foo/bar" }).with_status(204),
        stub(:storage, :delete_object, params: { "bucket" => "42", "object" => "foo/baz/qux" }).with_status(204)
      ]

      subject

      delete_stubs.each do |stub|
        expect(stub).to have_been_requested
      end
    end
  end
end
