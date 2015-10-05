class CreateCategories < ActiveRecord::Migration
  def up
    create_table :categories do |t|
      # t.string :title
      t.string :name
      t.string :color
      # t.boolean :show_in_menu, default: true
      # t.boolean :show_in_footer, default: false
      # t.integer :position
      t.boolean :optional, default: false
      t.references :optional_module, index: true
      t.references :menu, index: true

      t.timestamps null: false
    end
    # Category.create_translation_table! title: :string
  end

  def down
    drop_table :categories
    # Category.drop_translation_table!
  end
end
