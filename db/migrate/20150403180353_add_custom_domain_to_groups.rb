class AddCustomDomainToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :custom_domain, :string
    add_index :groups, :custom_domain
  end
end
