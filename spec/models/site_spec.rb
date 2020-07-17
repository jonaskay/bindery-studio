require 'rails_helper'

RSpec.describe Site, type: :model do
  describe "#valid?" do
    let(:site) { build(:site) }

    subject { site.valid? }

    it { is_expected.to be true }

    context "when publication is nil" do
      let(:site) { build(:site, publication: nil) }

      it { is_expected.to be false }
    end

    context "when name is blank" do
      let(:site) { build(:site, name: "   ") }

      it { is_expected.to be false }
    end

    context "when bucket is blank" do
      let(:site) { build(:site, bucket: "   ") }

      it { is_expected.to be false }
    end
  end

  describe "#url" do
    let(:site) { build(:site, name: "foo", bucket: "bar") }

    subject { site.url }

    it { is_expected.to eq("https://storage.googleapis.com/bar/foo/index.html") }
  end
end
