class AddPostablesToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :postable_id, :integer, index: true
    add_column :posts, :postable_type, :string
  end
end
