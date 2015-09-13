#
# == Imageable Concerns
#
module Imageable
  extend ActiveSupport::Concern
  include ApplicationHelper

  included do
    delegate :title, :description, to: :picture, prefix: true, allow_nil: true
  end

  #
  # == Pictures
  #
  def picture?
    picture.present? && picture.image.exists? && picture.online?
  end

  def pictures?
    pictures.online.first.present? && pictures.online.first.image.exists?
  end

  # check if own model has image
  def self_image?
    image.exists?
  end

  # Return first object model when :has_many relation
  def first_pictures
    pictures.online.first if pictures?
  end

  # Return first paperclip object when :has_many relation
  def first_pictures_image
    pictures.online.first.image if pictures?
  end

  # Return first paperclip object url by size when :has_many relation
  def first_picture_image_url_by_size(size)
    first_pictures_image.url(size) if pictures?
  end

  # Return paperclip object url by size when :has_one relation
  def image_url_by_size(size)
    picture.image.url(size) if picture?
  end

  # Return paperclip object url for own model
  def self_image_url_by_size(size)
    image.url(size)
  end

  #
  # == Background
  #
  def background?
    background.present? && background.image.exists?
  end

  #
  # == Slides
  #
  def slides?
    slides.online.first.present? && slides.online.first.image.exists?
  end
end
