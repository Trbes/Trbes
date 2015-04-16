require "rails_helper"

describe Comment do
  describe "associations" do
    it { is_expected.to belong_to(:post) }
    it { is_expected.to belong_to(:membership) }
    it { is_expected.to belong_to(:parent_comment).class_name("Comment").with_foreign_key("parent_comment_id") }
    it {
      is_expected.to have_many(:child_comments)
        .class_name("Comment")
        .with_foreign_key("parent_comment_id")
        .dependent(:destroy)
    }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:body) }
    it { is_expected.to validate_presence_of(:membership) }
    it { is_expected.to validate_presence_of(:post) }
  end

  describe "columns" do
    it { is_expected.to have_db_column(:body) }
    it { is_expected.to have_db_column(:membership_id) }
    it { is_expected.to have_db_column(:post_id) }

    it { is_expected.to have_db_index(:membership_id) }
    it { is_expected.to have_db_index(:post_id) }
  end
end
