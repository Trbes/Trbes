class MoveTitleToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :title, :string

    Post.all.each do |post|
      post.update_attributes(title: post.postable.title)
    end

    remove_column :text_postables, :title
    remove_column :image_postables, :title
    remove_column :link_postables, :title

    change_column_null :posts, :title, false
  end
end
