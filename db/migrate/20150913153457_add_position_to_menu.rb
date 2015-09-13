class AddPositionToMenu < ActiveRecord::Migration
  def change
    add_column :menus, :position, :integer, after: :ancestry
  end
end
