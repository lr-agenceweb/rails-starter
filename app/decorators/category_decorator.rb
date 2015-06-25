#
# == CategoryDecorator
#
class CategoryDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  delegate_all

  def background
    retina_image_tag model.background, :image, :small if background?
  end

  def show_in_menu
    arbre do
      status_tag "#{model.show_in_menu}", (model.show_in_menu? ? :ok : :warn)
    end
  end

  def show_in_footer
    arbre do
      status_tag "#{model.show_in_footer}", (model.show_in_footer? ? :ok : :warn)
    end
  end

  private

  def background?
    model.background.present?
  end
end
