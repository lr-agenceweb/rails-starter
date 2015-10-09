#
# == VideoDecorator
#
class VideoDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  delegate_all

  def from_article
    model.videoable
  end
end
