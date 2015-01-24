require "rails_helper"

describe CollectionPost do
  describe "associations" do
    it { is_expected.to belong_to(:collection) }
    it { is_expected.to belong_to(:post) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:collection) }
    it { is_expected.to validate_presence_of(:post) }
  end

  describe "columns" do
    it { is_expected.to have_db_column(:collection_id) }
    it { is_expected.to have_db_column(:post_id) }

    it { is_expected.to have_db_index(:collection_id) }
    it { is_expected.to have_db_index(:post_id) }
  end
end
