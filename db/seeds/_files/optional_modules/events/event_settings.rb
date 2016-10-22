# frozen_string_literal: true

#
# == Event Setting
#
puts 'Creating Event Setting'
EventSetting.create!(
  prev_next: true,
  show_map: true,
  event_order_id: @event_order.id
)
