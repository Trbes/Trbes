class AddVisibilityToCollections < ActiveRecord::Migration
  def change
    add_column :collections, :visibility, :boolean, default: false, null: false
  end
end
