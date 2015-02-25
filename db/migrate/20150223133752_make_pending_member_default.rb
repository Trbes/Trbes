class MakePendingMemberDefault < ActiveRecord::Migration
  def change
    change_column_default :memberships, :role, 3
  end
end
