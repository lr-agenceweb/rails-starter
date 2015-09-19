class CreateMenus < ActiveRecord::Migration
  def up
    create_table :menus do |t|
      t.string :title
      t.boolean :online, default: true
      t.boolean :show_in_footer, default: false
      t.string :ancestry

      t.timestamps null: false
    end

    Menu.create_translation_table! title: :string
  end

  def down
    drop_table :menus
    Menu.drop_translation_table!
  end
end
