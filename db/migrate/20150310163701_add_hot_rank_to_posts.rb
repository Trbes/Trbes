class AddHotRankToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :hot_rank, :float, default: 0, null: false
  end
end
