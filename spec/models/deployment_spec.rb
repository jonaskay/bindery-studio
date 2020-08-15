require "rails_helper"
require "support/helpers/googleapis_helper"

RSpec.shared_examples "successful failure" do
  it "returns true" do
    expect(subject).to be true
  end

  it "updates failed_at" do
    expect { subject }.to change { deployment.reload.failed_at }
  end
end

RSpec.shared_examples "skipped failure" do
  it "returns false" do
    expect(subject).to be false
  end

  it "doesn't update failed_at" do
    expect { subject }.not_to change { deployment.reload.failed_at }
  end

  it "doesn't update fail_message" do
    expect { subject }.not_to change { deployment.reload.fail_message }
  end
end

RSpec.describe Deployment, type: :model do
  include GoogleapisHelper

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
      context "when failed? is true" do
        let(:deployment) { build(:deployment, :finished, :failed) }

        it { is_expected.to be false }
      end

      context "when failed? is false" do
        let(:deployment) { build(:deployment, :finished) }

        it { is_expected.to be false }
      end
    end

    context "when finished? is false" do
      context "when failed? is true" do
        let(:deployment) { build(:deployment, :failed) }

        it { is_expected.to be false }
      end

      context "when failed? is false" do
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

  describe "#failed?" do
    subject { deployment.failed? }

    context "when failed_at is not nil" do
      let(:deployment) { build(:deployment, failed_at: Time.current) }

      it { is_expected.to be true }
    end

    context "when failed_at is nil" do
      let(:deployment) { build(:deployment, failed_at: nil) }

      it { is_expected.to be false }
    end
  end

  describe "#handle_success" do
    let(:deployment) { create(:deployment) }

    subject { deployment.handle_success(DateTime.parse("1970-01-01T00:00:00.000Z")) }

    it "updates finished_at" do
      expect { subject }.to change { deployment.reload.finished_at.to_s }.to("1970-01-01 00:00:00 UTC")
    end
  end

  describe "#handle_failure" do
    subject { deployment.handle_failure("foo") }

    context "when pending? is true" do
      let(:deployment) { create(:deployment, :pending) }

      include_examples "successful failure"

      it "updates fail_message" do
        expect { subject }.to change { deployment.reload.fail_message }.to("foo")
      end
    end

    context "when pending? is false" do
      let(:deployment) { create(:deployment, :failed) }

      include_examples "skipped failure"
    end
  end

  describe "#handle_timeout" do
    let(:compute_engine) { class_double(ComputeEngine).as_stubbed_const }

    before { allow(compute_engine).to receive(:delete_instance) }

    subject { deployment.handle_timeout }

    context "when pending? is true" do
      let(:deployment) { create(:deployment, :pending, instance: "foo") }

      include_examples "successful failure"

      it "updates fail_message" do
        expect { subject }.to change { deployment.reload.fail_message }.to("Timeout")
      end

      it "calls ComputeEngine.delete_instance" do
        expect(compute_engine).to receive(:delete_instance).with("foo")

        subject
      end
    end

    context "when pending? is false" do
      let(:deployment) { create(:deployment, :finished, instance: "foo") }

      include_examples "skipped failure"

      it "doesn't call ComputeEngine.delete_instance" do
        expect(compute_engine).not_to receive(:delete_instance)

        subject
      end
    end
  end
end
