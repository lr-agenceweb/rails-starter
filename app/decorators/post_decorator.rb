#
# == PostDecorator
#
class PostDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  delegate_all

  def image
    retina_image_tag first_picture, :image, :medium if picture?
  end

  def content
    model.content.html_safe
  end

  def online
    arbre do
      status_tag("#{model.online}", (model.online? ? :ok : :warn))
    end
  end

  # TODO: Improve method to handle this
  def image_and_content
    content
  end

  private

  def first_picture
    model.pictures.online.first if picture?
  end

  def picture?
    model.pictures.online.present?
  end
end
