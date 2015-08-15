class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.references :locationable, index: true, polymorphic: true
      t.string :address
      t.string :city
      t.integer :postcode
      t.float :latitude
      t.float :longitude
      t.string :geocode_address

      t.timestamps null: false
    end
  end
end
