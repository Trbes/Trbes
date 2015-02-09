class AddMembershipsCounterCacheToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :memberships_count, :integer, default: 0, null: false

    Group.all.each do |group|
      Group.reset_counters(group.id, :memberships)
    end
  end
end
