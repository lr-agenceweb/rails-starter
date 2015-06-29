#
# == Imageable Concerns
#
module Imageable
  extend ActiveSupport::Concern
  include ApplicationHelper

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

  def picture?
    pictures.online.first.present?
  end
end
