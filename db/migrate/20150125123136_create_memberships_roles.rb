class CreateMembershipsRoles < ActiveRecord::Migration
  def change
    create_table :memberships_roles, id: false do |t|
      t.references :membership, null: false
      t.references :role, null: false
    end
  end
end
