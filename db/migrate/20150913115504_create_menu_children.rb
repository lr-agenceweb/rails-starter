class CreateMenuChildren < ActiveRecord::Migration
  def up
    create_table :menu_children do |t|
      t.string :title
      t.boolean :online, default: true
      t.belongs_to :menu_parent, index: true, foreign_key: true

      t.timestamps null: false
    end

    MenuChild.create_translation_table! title: :string
  end

  def down
    drop_table :menu_children
    MenuChild.drop_translation_table!
  end
end
