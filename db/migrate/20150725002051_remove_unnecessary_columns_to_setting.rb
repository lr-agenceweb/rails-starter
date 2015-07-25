class RemoveUnnecessaryColumnsToSetting < ActiveRecord::Migration
  def change
    remove_column :settings, :address
    remove_column :settings, :city
    remove_column :settings, :postcode
    remove_column :settings, :geocode_address
    remove_column :settings, :latitude
    remove_column :settings, :longitude
    remove_column :settings, :show_map
  end
end
