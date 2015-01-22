class CreateDifferentPostables < ActiveRecord::Migration
  def change
    create_table :text_postables do |t|
      t.column :title, :string
      t.column :body, :text
    end

    create_table :image_postables do |t|
      t.column :title, :string
    end

    create_table :link_postables do |t|
      t.column :title, :string
      t.column :link, :string
    end
  end
end
