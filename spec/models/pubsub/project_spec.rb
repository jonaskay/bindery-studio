require "rails_helper"

RSpec.describe Pubsub::Project, type: :model do
  describe "#valid?" do
    let(:id)      { "42" }
    let(:payload) { { "id" => id } }
    let(:project) { Pubsub::Project.new(payload) }

    subject { project.valid? }

    context "when payload is valid" do
      it { is_expected.to be true }
    end

    context "when id is blank" do
      let(:id) { "   " }

      it { is_expected.to be false }
    end
  end
end
