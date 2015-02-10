class AddMoreCounterCachesToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :posts_count, :integer, default: 0, null: false
    add_column :groups, :collections_count, :integer, default: 0, null: false

    Group.all.each do |group|
      Group.reset_counters(group.id, *%i( posts collections ))
    end
  end
end
