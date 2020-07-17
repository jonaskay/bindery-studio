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

  describe "#publish" do
    let(:publisher) { class_double("Publisher").as_stubbed_const }

    before { allow(publisher).to receive(:publish).and_return("foo") }

    subject { publication.publish }

    context "when published_at is nil" do
      let(:publication) { create(:publication) }

      it { is_expected.to be true }

      it "creates a site" do
        expect { subject }.to change { Site.count }.by(1)
      end

      it "updates published_at" do
        subject
        publication.reload

        expect(publication.published_at).not_to be_nil
      end

      it "calls publisher" do
        expect(publisher).to receive(:publish)

        subject
      end
    end

    context "when published_at is not nil" do
      let(:publication) { create(:publication, published_at: Time.current) }

      it { is_expected.to be false }

      it "doesn't create a site" do
        expect { subject }.not_to change { Site.count }
      end

      it "doesn't update published_at" do
        published_at = publication.published_at

        subject
        publication.reload

        expect(publication.published_at.to_s).to eq(published_at.to_s)
      end

      it "doesn't call publisher" do
        expect(publisher).not_to receive(:publish)

        subject
      end
    end
  end

  context "when publication is destroyed" do
    let(:publication) { create(:publication) }

    before { create(:site, publication: publication) }

    subject { publication.destroy }

    it "destroys any sites" do
      expect { subject }.to change { Site.count }.by(-1)
    end
  end
end
