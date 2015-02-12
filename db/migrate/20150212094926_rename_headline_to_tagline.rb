class RenameHeadlineToTagline < ActiveRecord::Migration
  def change
    rename_column :groups, :headline, :tagline
  end
end
