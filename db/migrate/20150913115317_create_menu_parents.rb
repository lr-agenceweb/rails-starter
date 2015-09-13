class CreateMenuParents < ActiveRecord::Migration
  def up
    create_table :menu_parents do |t|
      t.string :title
      t.boolean :online, default: true
      t.boolean :show_in_footer, default: false
      t.belongs_to :category, index: true, foreign_key: true

      t.timestamps null: false
    end

    MenuParent.create_translation_table! title: :string
  end

  def down
    drop_table :menu_parents
    MenuParent.drop_translation_table!
  end
end
