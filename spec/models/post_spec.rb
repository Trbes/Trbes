require "rails_helper"

describe Post do
  describe "associations" do
    it { is_expected.to belong_to(:group) }
    it { is_expected.to belong_to(:membership) }
    it { is_expected.to have_many(:comments) }
    it { is_expected.to have_many(:attachments) }
  end

  describe "columns" do
    it { is_expected.to have_db_column(:group_id) }
    it { is_expected.to have_db_column(:membership_id) }
    it { is_expected.to have_db_column(:comments_count) }
    it { is_expected.to have_db_column(:slug) }
    it { is_expected.to have_db_column(:title) }
    it { is_expected.to have_db_column(:link) }
    it { is_expected.to have_db_column(:body) }

    it { is_expected.to have_db_index(:group_id) }
    it { is_expected.to have_db_index(:membership_id) }
    it { is_expected.to have_db_index(:slug) }
  end

  describe "normalizations" do
    it { is_expected.to normalize_attribute(:title) }
    it { is_expected.to normalize_attribute(:body).from("").to("") }
    it { is_expected.to normalize_attribute(:body).from("  Test  Body ").to("Test Body") }
    it {
      is_expected.to normalize_attribute(:body)
        .from("\r\n\r\nFirst.\r\nSecond.   \r\n\r\n\r\n Third. \r\n\r\n")
        .to("First.<br>Second. <br><br> Third.")
    }
  end
end
