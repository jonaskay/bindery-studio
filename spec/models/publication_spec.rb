require 'rails_helper'

RSpec.shared_examples "failed publish" do
  it { is_expected.to be false }

  it "doesn't update published_at" do
    expect { subject }.not_to change { publication.reload.published_at }
  end

  it "doesn't call Publisher.publish" do
    expect(publisher).not_to receive(:publish)

    subject
  end
end

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
    let(:publication) { build(:publication, name: "foo") }

    subject { publication.url }

    it { is_expected.to eq("http://www.example.com/foo/index.html") }
  end

  describe "#published?" do
    subject { publication.published? }

    context "when discarded is false and published_at is not nil" do
      let(:publication) { create(:publication, published_at: Time.current) }

      it { is_expected.to be true }
    end

    context "when discarded is true" do
      let(:publication) { create(:publication, :discarded, published_at: Time.current) }
    end

    context "when published_at is nil" do
      let(:publication) { create(:publication, published_at: nil) }

      it { is_expected.to be false }
    end
  end

  describe "#unpublished?" do
    subject { publication.unpublished? }

    context "when published is true" do
      let(:publication) { create(:publication, :published) }

      it { is_expected.to be false }
    end

    context "when published is false" do
      let(:publication) { create(:publication, :published) }

      it { is_expected.to be false }
    end
  end

  describe "#deployed?" do
    subject { publication.deployed? }

    context "when published is true and deployed_at is not nil" do
      let(:publication) { create(:publication, :published, deployed_at: Time.current) }

      it { is_expected.to be true }
    end

    context "when published is false" do
      let(:publication) { create(:publication, deployed_at: Time.current) }

      it { is_expected.to be false }
    end

    context "when deployed_at is nil" do
      let(:publication) { create(:publication, :published, deployed_at: nil) }

      it { is_expected.to be false }
    end
  end

  describe "#publish" do
    let(:publisher) { class_double("Publisher").as_stubbed_const }

    before { allow(publisher).to receive(:publish).and_return("foo") }

    subject { publication.publish }

    context "when published_at is nil and discarded is false" do
      let(:publication) { create(:publication) }

      it { is_expected.to be true }

      it "updates published_at" do
        expect { subject }.to change { publication.reload.published_at }
      end

      it "calls publisher" do
        expect(publisher).to receive(:publish)

        subject
      end
    end

    context "when discarded is true" do
      let(:publication) { create(:publication, :discarded) }

      include_examples "failed publish"
    end

    context "when published_at is not nil" do
      let(:publication) { create(:publication, :published) }

      include_examples "failed publish"
    end
  end

  describe "#unpublish" do
    let(:publisher) { class_double(Publisher).as_stubbed_const }
    let(:publication) { create(:publication, :published) }

    subject { publication.unpublish }

    before { allow(publisher).to receive(:unpublish).with(publication) }

    it "calls Publisher.unpublish" do
      expect(publisher).to receive(:unpublish).with(publication)

      subject
    end

    it "updates publication to unpublished" do
      expect { subject }.to change { publication.reload.unpublished? }
    end
  end

  describe "#confirm_deployment" do
    let(:publication) { create(:publication) }

    subject { publication.confirm_deployment(DateTime.parse("1970-01-01T00:00:00.000Z")) }

    it "updateds publication to deployed" do
      expect { subject }.to change { publication.reload.deployed_at.to_s }.to("1970-01-01 00:00:00 UTC")
    end
  end

  describe "#confirm_cleanup" do
    subject { publication.confirm_cleanup }

    context "when discarded is true" do
      let!(:publication) { create(:publication, :discarded) }

      it { is_expected.to be_a(Publication) }

      it "deletes publication" do
        expect { subject }.to change { Publication.count }.by(-1)
      end
    end

    context "when discarded is false" do
      let!(:publication) { create(:publication) }

      it { is_expected.to be false }

      it "doesn't delete publication" do
        expect { subject }.not_to change { Publication.count }
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

  context "when publication is discarded" do
    let(:publisher) { class_double("Publisher").as_stubbed_const }

    subject { publication.discard }

    context "when publication is not published" do
      let(:publication) { create(:publication) }

      it "doesn't unpublish the deployed site" do
        expect(publisher).not_to receive(:unpublish)

        subject
      end
    end

    context "when publication is published" do
      let(:publication) { create(:publication, :published) }

      it "unpublishes the deployed site" do
        expect(publisher).to receive(:unpublish).with(publication)

        subject
      end
    end
  end
end
