class RemoveUnnecessariesColumnsToMap < ActiveRecord::Migration
  def change
    remove_column :maps, :address
    remove_column :maps, :city
    remove_column :maps, :postcode
    remove_column :maps, :geocode_address
    remove_column :maps, :latitude
    remove_column :maps, :longitude
  end
end
