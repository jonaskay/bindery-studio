require "rails_helper"

RSpec.shared_examples "no timeout error" do
  it "doesn't update errored_at" do
    expect { subject }.not_to change { deployment.reload.errored_at }
  end

  it "doesn't update error_message" do
    expect { subject }.not_to change { deployment.reload.error_message }
  end
end

RSpec.describe DeploymentMonitor, type: :model do
  describe ".check_healths" do
    let(:finished_deployment) { create(:deployment, :finished) }
    let(:errored_deployment) { create(:deployment, :errored) }

    subject { described_class.check_healths }

    context "when deployment is pending" do
      let(:deployment) { pending_deployment }

      context "when deployment was created more than an hour ago" do
        let(:pending_deployment) { create(:deployment, :pending, created_at: 1.hour.ago) }

        it "updates errored_at" do
          expect { subject }.to change { deployment.reload.errored_at }
        end

        it "updates error_message" do
          expect { subject }.to change { deployment.reload.errored_at }
        end
      end

      context "when deployment was created less than an hour ago" do
        let(:pending_deployment) { create(:deployment, :pending, created_at: Time.current) }

        include_examples "no timeout error"
      end
    end

    context "when deployment has finished" do
      let(:deployment) { finished_deployment }

      include_examples "no timeout error"
    end

    context "when deployment has errored" do
      let(:deployment) { errored_deployment }

      include_examples "no timeout error"
    end
  end
end
