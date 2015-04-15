class AddCustomPostCounterCacheFieldsToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :published_posts_count, :integer, default: 0, null: false
    add_column :groups, :moderation_posts_count, :integer, default: 0, null: false
    add_column :groups, :rejected_posts_count, :integer, default: 0, null: false

    Post.counter_culture_fix_counts
  end
end
