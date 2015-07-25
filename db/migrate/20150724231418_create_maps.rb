class CreateMaps < ActiveRecord::Migration
  def change
    create_table :maps do |t|
      t.string :address
      t.string :city
      t.integer :postcode
      t.string :geocode_address
      t.float :latitude
      t.float :longitude
      t.boolean :show_map

      t.timestamps null: false
    end
  end
end
