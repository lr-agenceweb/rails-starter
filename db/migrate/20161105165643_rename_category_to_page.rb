class RenameCategoryToPage < ActiveRecord::Migration
  def change
    rename_table :categories, :pages
    rename_column :sliders, :category_id, :page_id
  end
end
