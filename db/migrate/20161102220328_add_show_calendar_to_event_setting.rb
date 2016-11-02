class AddShowCalendarToEventSetting < ActiveRecord::Migration
  def change
    add_column :event_settings, :show_calendar, :boolean, default: false, after: :prev_next
  end
end
