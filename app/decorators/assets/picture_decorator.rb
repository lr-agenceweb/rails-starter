#
# == PictureDecorator
#
class PictureDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  delegate_all

  def image
    base_image :small
  end

  def image_large
    base_image :large
  end

  def description
    model.description.html_safe if description?
  end

  def source_picture_title_link
    klass = source_picture.class.name.underscore.singularize.downcase
    link_to source_picture_title, send("admin_#{klass}_path", source_picture)
  end

  private

  # Article where the Picture comes from
  #
  #
  def source_picture
    model.attachable_type.constantize.find(model.attachable_id)
  end

  def source_picture_title
    source_picture.title
  end

  def base_image(size)
    retina_image_tag model, :image, size
  end
end
