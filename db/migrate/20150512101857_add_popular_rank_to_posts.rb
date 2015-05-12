class AddPopularRankToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :popular_rank, :float, default: 0, null: false
  end
end
