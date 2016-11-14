# frozen_string_literal: true

#
# == PictureDecorator
#
class PictureDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  delegate_all

  def title
    model.title if title?
  end

  def description
    safe_join [raw(model.description)] if description?
  end

  def source_picture_title_link
    klass = source_picture.class.name.underscore.singularize.downcase
    link_to source_picture_title, send("admin_#{klass}_path", source_picture)
  end

  def self_image_has_one_by_size(size = :large)
    retina_image_tag self, :image, size, data: interchange_self
  end

  #
  # == File
  #
  def file_name_without_extension
    super 'image'
  end

  private

  #
  # == Article where the Picture comes from
  #
  def source_picture
    model.attachable
  end

  def source_picture_title
    html = model.attachable_type == 'Page' ? source_picture.menu_title : source_picture.title
    safe_join [raw(html)]
  end

  def base_image(size)
    retina_image_tag model, :image, size
  end

  def interchange_self
    { interchange: "[#{model.self_image_url_by_size(:medium)}, small], [#{model.self_image_url_by_size(:medium)}, medium], [#{model.self_image_url_by_size(:large)}, large]" }
  end
end
