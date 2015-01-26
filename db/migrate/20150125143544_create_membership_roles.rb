class CreateMembershipRoles < ActiveRecord::Migration
  def change
    create_table :membership_roles do |t|
      t.references :membership, index: true, null: false
      t.references :role, index: true, null: false

      t.timestamps null: false
    end
    add_foreign_key :membership_roles, :memberships
    add_foreign_key :membership_roles, :roles
  end
end
