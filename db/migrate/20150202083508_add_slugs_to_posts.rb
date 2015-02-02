class AddSlugsToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :slug, :string
    add_index :posts, :slug, unique: true

    Post.find_each(&:save)

    change_column_null(:posts, :slug, false)
  end
end
