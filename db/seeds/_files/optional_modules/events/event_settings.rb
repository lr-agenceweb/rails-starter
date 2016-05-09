# frozen_string_literal: true

#
# == Event Setting
#
puts 'Creating Event Setting'
EventSetting.create!(prev_next: true, event_order_id: @event_order.id)
