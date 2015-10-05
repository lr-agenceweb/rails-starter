class CreateMaps < ActiveRecord::Migration
  def change
    create_table :maps do |t|
      t.string :marker_icon
      t.string :marker_color
      t.boolean :show_map

      t.timestamps null: false
    end
  end
end
