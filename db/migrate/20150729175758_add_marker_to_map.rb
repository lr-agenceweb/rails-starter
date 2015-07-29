class AddMarkerToMap < ActiveRecord::Migration
  def change
    add_column :maps, :marker_icon, :string, after: :longitude
    add_column :maps, :marker_color, :string, after: :marker_icon
  end
end
