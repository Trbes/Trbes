class AddCachedVotesToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :cached_votes_total, :integer, default: 0
    add_index  :posts, :cached_votes_total
  end
end
