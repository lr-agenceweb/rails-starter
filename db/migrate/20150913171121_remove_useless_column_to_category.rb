class RemoveUselessColumnToCategory < ActiveRecord::Migration
  def change
    remove_column :categories, :show_in_menu
    remove_column :categories, :show_in_footer
    remove_column :categories, :position
    remove_column :categories, :title
    drop_table :category_translations
  end
end
