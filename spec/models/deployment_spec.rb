require 'rails_helper'

RSpec.describe Deployment, type: :model do
  describe "#valid?" do
    subject { deployment.valid? }

    context "when attributes are valid" do
      let(:deployment) { build(:deployment) }

      it { is_expected.to be true }
    end

    context "when project is nil" do
      let(:deployment) { build(:deployment, project: nil) }

      it { is_expected.to be false }
    end

    context "when instance is blank" do
      let(:deployment) { build(:deployment, instance: "   ") }

      it { is_expected.to be false }
    end
  end

  describe "#pending?" do
    subject { deployment.pending? }

    context "when finished? is true" do
      context "when errored? is true" do
        let(:deployment) { build(:deployment, :finished, :errored) }

        it { is_expected.to be false }
      end

      context "when errored? is false" do
        let(:deployment) { build(:deployment, :finished) }

        it { is_expected.to be false }
      end
    end

    context "when finished? is false" do
      context "when errored? is true" do
        let(:deployment) { build(:deployment, :errored) }

        it { is_expected.to be false }
      end

      context "when errored? is false" do
        let(:deployment) { build(:deployment) }

        it { is_expected.to be true }
      end
    end
  end

  describe "#finished?" do
    subject { deployment.finished? }

    context "when finished_at is not nil" do
      let(:deployment) { build(:deployment, finished_at: Time.current) }

      it { is_expected.to be true }
    end

    context "when finished_at is nil" do
      let(:deployment) { build(:deployment, finished_at: nil) }

      it { is_expected.to be false }
    end
  end

  describe "#errored?" do
    subject { deployment.errored? }

    context "when errored_at is not nil" do
      let(:deployment) { build(:deployment, errored_at: Time.current) }

      it { is_expected.to be true }
    end

    context "when errored_at is nil" do
      let(:deployment) { build(:deployment, errored_at: nil) }

      it { is_expected.to be false }
    end
  end

  describe "#handle_failure" do
    subject { deployment.handle_failure("foo") }

    context "when pending? is true" do
      let(:deployment) { create(:deployment, :pending) }

      it "returns true" do
        expect(subject).to be true
      end

      it "updates errored_at" do
        expect { subject }.to change { deployment.reload.errored_at }
      end

      it "updates error_message" do
        expect { subject }.to change { deployment.reload.error_message }.to("foo")
      end
    end

    context "when pending? is false" do
      let(:deployment) { create(:deployment, :errored) }

      it "returns false" do
        expect(subject).to be false
      end

      it "doesn't update errored_at" do
        expect { subject }.not_to change { deployment.reload.errored_at }
      end

      it "doesn't update error_message" do
        expect { subject }.not_to change { deployment.reload.error_message }
      end
    end
  end
end
