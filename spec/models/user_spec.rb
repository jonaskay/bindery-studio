require 'rails_helper'

RSpec.describe User, type: :model do
  describe "#valid?" do
    subject { build(:user).valid? }

    it { is_expected.to be true }
  end

  context "when user is destroyed" do
    let(:user) { create(:user) }
    before { create(:publication, user: user) }

    subject { user.destroy }

    it "destroys any publications" do
      expect { subject }.to change { Publication.count }.by(-1)
    end
  end
end
