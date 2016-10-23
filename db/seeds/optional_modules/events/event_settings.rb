# frozen_string_literal: true

#
# == Event Setting
#
puts 'Creating EventSetting'
EventSetting.create!(
  prev_next: true,
  show_map: true,
  event_order_id: @event_order.id
)
