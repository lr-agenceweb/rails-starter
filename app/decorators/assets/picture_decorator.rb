#
# == PictureDecorator
#
class PictureDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  delegate_all

  def title
    raw(model.title) if title?
  end

  def description
    raw(model.description) if description?
  end

  def source_picture_title_link
    klass = source_picture.class.name.underscore.singularize.downcase
    link_to source_picture_title, send("admin_#{klass}_path", source_picture)
  end

  def self_image_has_one_by_size(size = :large)
    retina_image_tag self, :image, size, data: interchange_self
  end

  private

  #
  # Article where the Picture comes from
  #
  def source_picture
    model.attachable
  end

  def source_picture_title
    return source_picture.menu_title if model.attachable_type == 'Category'
    raw(source_picture.title)
  end

  def base_image(size)
    retina_image_tag model, :image, size
  end

  def interchange_self
    { interchange: "[#{model.self_image_url_by_size(:large)}, (default)], [#{model.self_image_url_by_size(:medium)}, (small)], [#{model.self_image_url_by_size(:medium)}, (medium)], [#{model.self_image_url_by_size(:large)}, (large)]" }
  end
end
