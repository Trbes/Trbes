class RemoveTitleFromPosts < ActiveRecord::Migration
  def change
    remove_column :posts, :title
    remove_column :posts, :body
  end
end
