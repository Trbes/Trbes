class AddTitleToUser < ActiveRecord::Migration
  def change
    add_column :users, :title, :string, null: false, default: ""
  end
end
