# == Schema Information
#
# Table name: event_orders
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

#
# == EventOrder Model
#
class EventOrder < ActiveRecord::Base
end
