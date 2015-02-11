class AddAllowedPostTypesToGroup < ActiveRecord::Migration
  def change
    add_column :groups, :allow_image_posts, :boolean
    add_column :groups, :allow_text_posts, :boolean
    add_column :groups, :allow_link_posts, :boolean
  end
end
