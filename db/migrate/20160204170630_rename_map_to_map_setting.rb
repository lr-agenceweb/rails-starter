class RenameMapToMapSetting < ActiveRecord::Migration
  def change
    remove_column :maps, :show_map
    rename_table :maps, :map_settings
  end
end
