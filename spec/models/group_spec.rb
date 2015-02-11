require "rails_helper"

describe Group do
  describe "associations" do
    it { is_expected.to have_many(:posts).dependent(:destroy) }
    it { is_expected.to have_many(:memberships).dependent(:destroy) }
    it { is_expected.to have_many(:collections).dependent(:destroy) }
  end

  describe "validations" do
    subject { build(:group) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:subdomain) }

    it { is_expected.to validate_uniqueness_of(:name) }
    it { is_expected.to validate_uniqueness_of(:subdomain) }

    it "should have a valid subdomain" do
      expect(build(:group, subdomain: "www")).not_to be_valid
      expect(build(:group, subdomain: "speci@l")).not_to be_valid
      expect(build(:group, subdomain: "normal")).to be_valid
    end
  end

  describe "columns" do
    it { is_expected.to have_db_column(:name) }
    it { is_expected.to have_db_column(:description) }
    it { is_expected.to have_db_column(:subdomain) }
    it { is_expected.to have_db_column(:private) }
    it { is_expected.to have_db_column(:allow_image_posts) }
    it { is_expected.to have_db_column(:allow_link_posts) }
    it { is_expected.to have_db_column(:allow_text_posts) }
  end

  describe "normalizations" do
    it { is_expected.to normalize_attribute(:name) }
    it { is_expected.to normalize_attribute(:description) }
    it { is_expected.to normalize_attribute(:subdomain) }
  end
end
