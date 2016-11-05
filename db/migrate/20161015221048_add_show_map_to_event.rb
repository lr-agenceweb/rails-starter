class AddShowMapToEvent < ActiveRecord::Migration
  def change
    add_column :events, :show_map, :boolean, default: false, after: :show_calendar
  end
end
