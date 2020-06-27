require 'rails_helper'

RSpec.describe Publication, type: :model do
  describe "#valid?" do
    let(:publication) { build(:publication) }
    subject { publication.valid? }

    it { is_expected.to be true }

    context "when user is nil" do
      let(:publication) { build(:publication, user: nil) }

      it { is_expected.to be false }
    end

    context "when title is blank" do
      let(:publication) { build(:publication, title: "   ") }

      it { is_expected.to be false }
    end
  end
end
