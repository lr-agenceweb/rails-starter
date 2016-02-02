class CreateStringBoxes < ActiveRecord::Migration
  def up
    create_table :string_boxes do |t|
      t.string :key, index: true, unique: true
      t.string :title
      t.text :content
      t.text :description
      t.references :optional_module, index: true

      t.timestamps null: false
    end

    StringBox.create_translation_table! title: :string, content: :text
  end

  def down
    drop_table :string_boxes
    StringBox.drop_translation_table!
  end
end
