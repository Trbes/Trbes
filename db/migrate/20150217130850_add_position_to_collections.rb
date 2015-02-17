class AddPositionToCollections < ActiveRecord::Migration
  def change
    add_column :collections, :row_order, :integer
  end
end
