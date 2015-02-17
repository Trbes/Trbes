class RemoveNotNullConstraintFromPostsBody < ActiveRecord::Migration
  def change
    change_column_null :posts, :body, true
  end
end
