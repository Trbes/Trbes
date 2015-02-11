class AddAllowedPostTypesToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :allow_image_posts, :boolean, null: false, default: true
    add_column :groups, :allow_link_posts, :boolean, null: false, default: true
    add_column :groups, :allow_text_posts, :boolean, null: false, default: true
  end
end
