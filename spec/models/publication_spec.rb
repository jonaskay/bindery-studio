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

  describe "publish" do
    let(:publisher) { class_double("Publisher").as_stubbed_const }

    before { allow(publisher).to receive(:publish) }

    context "when published_at is nil" do
      let(:publication) { create(:publication) }

      it "returns true" do
        expect(publication.publish).to be true
      end

      it "updates published_at" do
        publication.publish
        publication.reload

        expect(publication.published_at).not_to be_nil
      end

      it "calls publisher" do
        expect(publisher).to receive(:publish)

        publication.publish
      end
    end

    context "when published_at is not nil" do
      let(:publication) { create(:publication, published_at: Time.current) }

      it "returns false" do
        expect(publication.publish).to be false
      end

      it "doesn't update published_at" do
        published_at = publication.published_at

        publication.publish
        publication.reload

        expect(publication.published_at.to_s).to eq(published_at.to_s)
      end

      it "doesn't call publisher" do
        expect(publisher).not_to receive(:publish)

        publication.publish
      end
    end
  end
end
