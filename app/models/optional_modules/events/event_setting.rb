# frozen_string_literal: true

# == Schema Information
#
# Table name: event_settings
#
#  id             :integer          not null, primary key
#  event_order_id :integer
#  prev_next      :boolean          default(FALSE)
#  show_map       :boolean          default(FALSE)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_event_settings_on_event_order_id  (event_order_id)
#

#
# == EventSetting Model
#
class EventSetting < ActiveRecord::Base
  include MaxRowable

  belongs_to :event_order
end
