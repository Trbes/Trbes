class CreateCollections < ActiveRecord::Migration
  def change
    create_table :collections do |t|
      t.string :image, null: false
      t.string :name, null: false
      t.text :description
      t.references :group, index: true, null: false

      t.timestamps null: false
    end
    add_foreign_key :collections, :groups
  end
end
