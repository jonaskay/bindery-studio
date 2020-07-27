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

    context "when name is blank" do
      let(:publication) { build(:publication, name: "   ") }

      it { is_expected.to be false }
    end

    context "when name is 63 characters long" do
      let(:publication) { build(:publication, name: "a" * 63) }

      it { is_expected.to be true }
    end

    context "when name is longer than 63 characters" do
      let(:publication) { build(:publication, name: "a" * 64) }

      it { is_expected.to be false }
    end

    context "when name contains uppercase letters" do
      let(:publication) { build(:publication, name: "fooBarBaz") }

      it { is_expected.to be false }
    end

    context "when name contains digits" do
      let(:publication) { build(:publication, name: "f00b4rb4z") }

      it { is_expected.to be true }
    end

    context "when name contains dashes" do
      let(:publication) { build(:publication, name: "foo-bar-baz") }

      it { is_expected.to be true }
    end

    context "when name contains underscores" do
      let(:publication) { build(:publication, name: "foo_bar_baz") }

      it { is_expected.to be false }
    end

    context "when name contains whitespace characters" do
      let(:publication) { build(:publication, name: "foo bar baz") }

      it { is_expected.to be false }
    end

    context "when name starts with a non-letter character" do
      let(:publication) { build(:publication, name: "42-foo-bar-baz") }

      it { is_expected.to be false }
    end

    context "when name ends with a dash" do
      let(:publication) { build(:publication, name: "foo-bar-baz-") }

      it { is_expected.to be false }
    end
  end

  describe "#url" do
    subject { publication.url }

    context "when bucket is not nil" do
      let(:publication) { build(:publication, name: "foo", bucket: "bar") }

      it { is_expected.to eq("https://storage.googleapis.com/bar/foo/index.html") }
    end

    context "when bucket is nil" do
      let(:publication) { build(:publication, name: "foo") }

      it { is_expected.to be_nil }
    end
  end

  describe "#published?" do
    subject { publication.published? }

    context "when published_at is not nil" do
      let(:publication) { create(:publication, published_at: Time.now) }

      it { is_expected.to be true }
    end

    context "when published_at is nil" do
      let(:publication) { create(:publication, published_at: nil) }

      it { is_expected.to be false }
    end
  end

  describe "#deployed?" do
    subject { publication.deployed? }

    context "when deployed_at and published_at are not nil" do
      let(:publication) { create(:publication, published_at: Time.now, deployed_at: Time.now) }

      it { is_expected.to be true }
    end

    context "when published_at is nil" do
      let(:publication) { create(:publication, published_at: nil, deployed_at: Time.now) }

      it { is_expected.to be false }
    end

    context "when deployed_at is nil" do
      let(:publication) { create(:publication, published_at: Time.now, deployed_at: nil) }

      it { is_expected.to be false }
    end
  end

  describe "#publish" do
    let(:publisher) { class_double("Publisher").as_stubbed_const }

    before { allow(publisher).to receive(:publish).and_return("foo") }

    subject { publication.publish }

    context "when published_at is nil" do
      let(:publication) { create(:publication) }

      it { is_expected.to be true }

      it "updates bucket" do
        expect { subject }.to change { publication.reload.bucket }
      end

      it "updates published_at" do
        expect { subject }.to change { publication.reload.published_at }
      end

      it "calls publisher" do
        expect(publisher).to receive(:publish)

        subject
      end
    end

    context "when published_at is not nil" do
      let(:publication) { create(:publication, published_at: Time.current) }

      it { is_expected.to be false }

      it "doesn't update bucket" do
        expect { subject }.not_to change { publication.reload.bucket }
      end

      it "doesn't update published_at" do
        expect { subject }.not_to change { publication.reload.published_at }
      end

      it "doesn't call publisher" do
        expect(publisher).not_to receive(:publish)

        subject
      end
    end
  end

  context "when publication is updated" do
    let(:publication) { create(:publication, title: "foo", name: "foo") }

    subject { publication.update(title: "bar", name: "bar") }

    it "prevents name updates" do
      expect { subject }.not_to change { publication.reload.name }
    end
  end
end
