class AddShowMapToEventSetting < ActiveRecord::Migration
  def change
    add_column :event_settings, :show_map, :boolean, after: :prev_next, default: false
  end
end
