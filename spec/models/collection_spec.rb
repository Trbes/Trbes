require "rails_helper"

describe Collection do
  describe "associations" do
    it { is_expected.to belong_to(:group) }
  end

  describe "validations" do
    describe "uniqueness" do
      subject { build(:collection) }
      it { is_expected.to validate_uniqueness_of(:name).scoped_to(:group_id) }
      it { is_expected.to validate_uniqueness_of(:icon_class).scoped_to(:group_id) }
    end

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:group) }
  end

  describe "columns" do
    it { is_expected.to have_db_column(:name) }
    it { is_expected.to have_db_column(:description) }
    it { is_expected.to have_db_column(:icon_class) }
    it { is_expected.to have_db_column(:group_id) }

    it { is_expected.to have_db_index(:group_id) }
  end
end
