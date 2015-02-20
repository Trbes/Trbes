class AddRowOrderToCollectionPosts < ActiveRecord::Migration
  def change
    add_column :collection_posts, :row_order, :integer
  end
end
