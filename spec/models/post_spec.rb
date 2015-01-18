require 'rails_helper'

describe Post do
  describe 'associations' do
    it { is_expected.to belong_to(:group) }
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to have_db_column(:group_id) }
    it { is_expected.to have_db_column(:user_id) }
  end

  describe 'columns' do
    it { is_expected.to have_db_column(:title) }
    it { is_expected.to have_db_column(:body) }
    it { is_expected.to have_db_column(:group_id) }
    it { is_expected.to have_db_column(:user_id) }

    it { is_expected.to have_db_index(:group_id) }
    it { is_expected.to have_db_index(:user_id) }
  end
end
