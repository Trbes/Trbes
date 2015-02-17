class AddRolesToMemberships < ActiveRecord::Migration
  def change
    drop_table :membership_roles
    drop_table :roles

    add_column :memberships, :role, :integer, default: 0, null: false
  end
end
