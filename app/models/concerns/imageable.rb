#
# == Imageable Concerns
#
module Imageable
  extend ActiveSupport::Concern
  include ApplicationHelper

  #
  # == Pictures
  #
  def picture?
    picture.present? && picture.image.exists?
  end

  def pictures?
    pictures.online.first.present? && pictures.online.first.image.exists?
  end

  def first_pictures
    pictures.online.first if pictures?
  end

  def self_image?
    image.exists?
  end

  #
  # == Background
  #
  def background?
    background.present? && background.image.exists?
  end

  def bg_background
    image.url(:background)
  end

  def bg_large
    image.url(:large)
  end

  def bg_medium
    image.url(:medium)
  end
end
