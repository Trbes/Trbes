class AddIconClassToCollections < ActiveRecord::Migration
  def change
    add_column :collections, :icon_class, :string
  end
end
