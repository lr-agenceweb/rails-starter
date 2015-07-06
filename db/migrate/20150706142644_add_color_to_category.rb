class AddColorToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :color, :string, after: :name
  end
end
