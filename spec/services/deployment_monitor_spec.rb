require "rails_helper"
require "support/helpers/googleapis_helper"

RSpec.shared_examples "no timeout error" do
  it "doesn't call Deployment#handle_timeout" do
    expect_any_instance_of(Deployment).not_to receive(:handle_timeout)

    subject
  end
end

RSpec.describe DeploymentMonitor, type: :model do
  describe ".check_healths" do
    let(:finished_deployment) { create(:deployment, :finished) }
    let(:failed_deployment) { create(:deployment, :failed) }

    subject { described_class.check_healths }

    context "when deployment is pending" do
      let!(:deployment) { pending_deployment }

      before { allow_any_instance_of(Deployment).to receive(:handle_timeout) }

      context "when deployment was created more than an hour ago" do
        let(:pending_deployment) { create(:deployment, :pending, created_at: 1.hour.ago) }

        it "calls Deployment#handle_timeout" do
          expect_any_instance_of(Deployment).to receive(:handle_timeout)

          subject
        end
      end

      context "when deployment was created less than an hour ago" do
        let(:pending_deployment) { create(:deployment, :pending, created_at: Time.current) }

        include_examples "no timeout error"
      end
    end

    context "when deployment has finished" do
      let!(:deployment) { finished_deployment }

      include_examples "no timeout error"
    end

    context "when deployment has failed" do
      let!(:deployment) { failed_deployment }

      include_examples "no timeout error"
    end
  end
end
