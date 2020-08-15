require "rails_helper"

RSpec.describe Publisher, type: :model do
  describe ".publish" do
    let(:compute_engine) { class_double(ComputeEngine).as_stubbed_const }
    let(:project) { create(:project, id: "13371337-1337-1337-1337-133713371337") }

    before { allow(compute_engine).to receive(:insert_instance) }

    subject { described_class.publish(project) }

    it "calls ComputeEngine.insert_instance" do
      expect(compute_engine).to(
        receive(:insert_instance).with(
          "compositor-13371337-1337-1337-1337-133713371337",
          "my-compositor-template"
        )
      )

      subject
    end

    it "creates a new deployment" do
      expect { subject }.to change { project.deployments.count }.by(1)
    end
  end
end
