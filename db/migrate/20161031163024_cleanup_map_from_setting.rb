class CleanupMapFromSetting < ActiveRecord::Migration
  def change
    remove_column :settings, :show_map
    add_column :map_settings, :show_map, :boolean, default: false, after: :marker_color
  end
end
