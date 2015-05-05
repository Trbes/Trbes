class AddDeletedAtFieldToGroupRelatedTables < ActiveRecord::Migration
  def change
    add_column :comments, :deleted_at, :datetime
    add_column :memberships, :deleted_at, :datetime
    add_column :collections, :deleted_at, :datetime
    add_column :collection_posts, :deleted_at, :datetime
    add_column :votes, :deleted_at, :datetime
    add_column :users, :deleted_at, :datetime

    add_index :comments, :deleted_at
    add_index :memberships, :deleted_at
    add_index :collections, :deleted_at
    add_index :collection_posts, :deleted_at
    add_index :votes, :deleted_at
    add_index :users, :deleted_at
  end
end
