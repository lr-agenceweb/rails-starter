class CreateCategories < ActiveRecord::Migration
  def up
    create_table :categories do |t|
      t.string :title
      t.string :name
      t.boolean :show_in_menu, default: true
      t.boolean :show_in_footer, default: false

      t.timestamps null: false
    end
    Category.create_translation_table! title: :string
  end

  def down
    drop_table :categories
    Category.drop_translation_table!
  end
end
