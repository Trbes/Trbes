class AddStateToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :state, :integer, default: 0, null: false
  end
end
