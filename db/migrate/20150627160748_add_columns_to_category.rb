class AddColumnsToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :optional, :boolean, default: false, after: :position
    add_reference :categories, :optional_module, index: true, after: :optional
    add_foreign_key :categories, :optional_modules
  end
end
