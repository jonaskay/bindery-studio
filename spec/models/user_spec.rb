require 'rails_helper'

RSpec.describe User, type: :model do
  describe "#valid?" do
    subject { build(:user).valid? }

    it { is_expected.to be true }
  end
end
