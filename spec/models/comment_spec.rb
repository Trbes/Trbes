require "rails_helper"

describe Comment do
  describe "associations" do
    it { is_expected.to belong_to(:post) }
    it { is_expected.to belong_to(:user) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:body) }
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:post) }
  end

  describe "columns" do
    it { is_expected.to have_db_column(:body) }
    it { is_expected.to have_db_column(:user_id) }
    it { is_expected.to have_db_column(:post_id) }

    it { is_expected.to have_db_index(:user_id) }
    it { is_expected.to have_db_index(:post_id) }
  end
end