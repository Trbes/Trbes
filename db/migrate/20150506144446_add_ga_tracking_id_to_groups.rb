class AddGaTrackingIdToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :ga_tracking_id, :string
  end
end
