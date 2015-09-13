class CreateMenus < ActiveRecord::Migration
  def change
    create_table :menus do |t|
      t.string :title
      t.boolean :online

      t.timestamps null: false
    end
  end
end
