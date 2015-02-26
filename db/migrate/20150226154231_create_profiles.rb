class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.references :user, index: true, null: false
      t.string :provider, null: false
      t.string :uid, null: false

      t.timestamps null: false
    end
    add_foreign_key :profiles, :users
  end
end
