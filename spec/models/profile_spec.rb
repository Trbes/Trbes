require "rails_helper"

describe Profile do
  describe "associations" do
    it { is_expected.to belong_to(:user) }
  end

  describe "validations" do
    subject { build(:profile) }

    it { is_expected.to validate_presence_of(:uid) }
    it { is_expected.to validate_presence_of(:provider) }

    it { is_expected.to validate_uniqueness_of(:uid).scoped_to(:provider) }
  end
end
