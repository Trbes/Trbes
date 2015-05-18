class AddFaviconToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :favicon, :string
  end
end
