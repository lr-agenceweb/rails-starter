# frozen_string_literal: true

#
# == VideoDecorator
#
class VideoDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  delegate_all

  def from_article
    model.videoable
  end

  def description_d
    safe_join [raw(model.description)]
  end
end
