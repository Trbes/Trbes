class AddSlugsToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :slug, :string, index: true, uniq: true

    Post.find_each(&:save)

    change_column_null(:posts, :slug, false)
  end
end
