#
# == VideoSubtitleDecorator
#
class VideoSubtitleDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  include AssetsHelper

  delegate_all
  decorates_association :posts
end
