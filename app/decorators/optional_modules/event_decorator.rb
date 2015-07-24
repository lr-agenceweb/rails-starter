#
# == EventDecorator
#
class EventDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  delegate_all
end