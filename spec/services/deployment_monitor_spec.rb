require "rails_helper"

RSpec.shared_examples "no timeout error" do
  it "doesn't update failed_at" do
    expect { subject }.not_to change { deployment.reload.failed_at }
  end

  it "doesn't update fail_message" do
    expect { subject }.not_to change { deployment.reload.fail_message }
  end
end

RSpec.describe DeploymentMonitor, type: :model do
  describe ".check_healths" do
    let(:finished_deployment) { create(:deployment, :finished) }
    let(:failed_deployment) { create(:deployment, :failed) }

    subject { described_class.check_healths }

    context "when deployment is pending" do
      let(:deployment) { pending_deployment }

      context "when deployment was created more than an hour ago" do
        let(:pending_deployment) { create(:deployment, :pending, created_at: 1.hour.ago) }

        it "updates failed_at" do
          expect { subject }.to change { deployment.reload.failed_at }
        end

        it "updates fail_message" do
          expect { subject }.to change { deployment.reload.failed_at }
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

    context "when deployment has failed" do
      let(:deployment) { failed_deployment }

      include_examples "no timeout error"
    end
  end
end
