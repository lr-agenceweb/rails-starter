#
# == CategoryDecorator
#
class CategoryDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  delegate_all

  def background_image
    retina_image_tag model.background, :image, :small if background?
  end

  private

  def background?
    model.background.present?
  end
end
