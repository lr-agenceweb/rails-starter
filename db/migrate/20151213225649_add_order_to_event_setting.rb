class AddOrderToEventSetting < ActiveRecord::Migration
  def change
    add_reference :event_settings, :event_order, index: true, foreign_key: true, after: :id
  end
end
