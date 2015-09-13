#
# == MenuDecorator
#
class MenuDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  delegate_all
end
