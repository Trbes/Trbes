class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.string :image, null: false
      t.string :attachable_type, null: false
      t.integer :attachable_id, null: false, index: true

      t.timestamps null: false
    end
  end
end
