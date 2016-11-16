# frozen_string_literal: true

#
# == EventOrder Model
#
class EventOrder < ApplicationRecord
  has_one :event_setting
end

# == Schema Information
#
# Table name: event_orders
#
#  id         :integer          not null, primary key
#  key        :string(255)
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
