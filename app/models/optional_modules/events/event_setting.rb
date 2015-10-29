# == Schema Information
#
# Table name: event_settings
#
#  id         :integer          not null, primary key
#  prev_next  :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

#
# == EventSetting Model
#
class EventSetting < ActiveRecord::Base
end
