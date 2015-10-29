#
# == EventSettingDecorator
#
class EventSettingDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  delegate_all
end
