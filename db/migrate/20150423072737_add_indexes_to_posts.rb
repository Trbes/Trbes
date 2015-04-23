class AddIndexesToPosts < ActiveRecord::Migration
  def change
    add_index :posts, [:group_id, :state, :cached_votes_total, :created_at], name: :posts_list_index
  end
end
