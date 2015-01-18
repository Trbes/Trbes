class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name, null: false
      t.text :description
      t.boolean :private, default: false
      t.string :subdomain, null: false

      t.timestamps
    end
  end
end
