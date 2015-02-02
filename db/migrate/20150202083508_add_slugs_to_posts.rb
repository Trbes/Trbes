class AddSlugsToPosts < ActiveRecord::Migration
  def change
    change_table :posts do |t|
      t.string :slug, index: true, uniq: true
    end

    Post.find_each(&:save)

    change_column_null(:posts, :slug, false)
  end
end
