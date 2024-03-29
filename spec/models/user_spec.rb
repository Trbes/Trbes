require "rails_helper"

describe User do
  describe "associations" do
    it { is_expected.to have_many(:posts).through(:memberships) }
    it { is_expected.to have_many(:comments).through(:memberships) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:full_name) }
  end

  describe "columns" do
    it { is_expected.to have_db_column(:email) }
    it { is_expected.to have_db_column(:full_name) }
    it { is_expected.to have_db_column(:title) }
    it { is_expected.to have_db_column(:encrypted_password) }

    it { is_expected.to have_db_index(:email) }
    it { is_expected.to have_db_index(:reset_password_token) }
  end
end
