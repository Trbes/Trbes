class AddStateToComments < ActiveRecord::Migration
  def change
    add_column :comments, :state, :integer, default: 0, null: false
  end
end
