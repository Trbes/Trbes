class AddPostsCountToCollections < ActiveRecord::Migration
  def change
    add_column :collections, :collection_posts_count, :integer, default: 0, null: false
  end
end
