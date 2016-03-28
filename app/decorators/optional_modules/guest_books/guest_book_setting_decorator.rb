#
# == GuestBookSettingDecorator
#
class GuestBookSettingDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  delegate_all
end
