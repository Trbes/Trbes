class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.references :group, index: true, null: false
      t.string :title, null: false
      t.text :body, null: false
      t.references :user, index: true, null: false

      t.timestamps null: false
    end
    add_foreign_key :posts, :groups
    add_foreign_key :posts, :users
  end
end
