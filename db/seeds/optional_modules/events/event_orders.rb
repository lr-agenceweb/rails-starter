# frozen_string_literal: true

#
# == Event Order
#
puts 'Creating Event Order'
event_order_key = %w(current_or_coming all)
event_order_name = ['Courant et à venir (avec le plus récent en premier)', 'Tous (même ceux qui sont déjà passés)']

event_order_name.each_with_index do |order, index|
  eo = EventOrder.create!(key: event_order_key[index], name: order)
  @event_order = eo if index.zero?
end
