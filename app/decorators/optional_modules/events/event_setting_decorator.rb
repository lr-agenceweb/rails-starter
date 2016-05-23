# frozen_string_literal: true

#
# == EventSettingDecorator
#
class EventSettingDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  delegate_all
end
