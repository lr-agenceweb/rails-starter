#
# == VideoSettingDecorator
#
class VideoSettingDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  delegate_all
end
