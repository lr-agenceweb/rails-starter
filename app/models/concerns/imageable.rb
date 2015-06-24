#
# == Imageable Concerns
#
module Imageable
  extend ActiveSupport::Concern
  include ApplicationHelper

  def picture?
    picture.present? && picture.online
  end

  def picture_medium
    picture.image.url(:medium) if picture?
  end

  def background?
    image.present?
  end

  def background
    image.url(:background)
  end

  def large
    image.url(:large)
  end

  def medium
    image.url(:medium)
  end
end
