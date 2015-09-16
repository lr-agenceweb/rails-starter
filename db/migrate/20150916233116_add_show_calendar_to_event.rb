class AddShowCalendarToEvent < ActiveRecord::Migration
  def change
    add_column :events, :show_calendar, :boolean, default: false, after: :show_as_gallery
  end
end
