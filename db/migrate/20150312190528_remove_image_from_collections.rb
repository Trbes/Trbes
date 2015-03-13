class RemoveImageFromCollections < ActiveRecord::Migration
  def change
    remove_column :collections, :image
  end
end
