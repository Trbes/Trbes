class AddFavouriteToComments < ActiveRecord::Migration
  def change
    add_column :comments, :favourite, :boolean, default: false, null: false
  end
end
