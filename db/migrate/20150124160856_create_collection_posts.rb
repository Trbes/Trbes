class CreateCollectionPosts < ActiveRecord::Migration
  def change
    create_table :collection_posts do |t|
      t.references :post, index: true, null: false
      t.references :collection, index: true, null: false

      t.timestamps null: false
    end
    add_foreign_key :collection_posts, :posts
    add_foreign_key :collection_posts, :collections
  end
end
