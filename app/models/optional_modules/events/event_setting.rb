# == Schema Information
#
# Table name: event_settings
#
#  id             :integer          not null, primary key
#  event_order_id :integer
#  prev_next      :boolean          default(FALSE)
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
  has_one :event_order
end
