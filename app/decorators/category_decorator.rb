#
# == CategoryDecorator
#
class CategoryDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  delegate_all

  def background
    if background?
      retina_image_tag model.background, :image, :small
    else
      'Pas de Background associé'
    end
  end

  def in_menu
    arbre do
      status_tag I18n.t(model.show_in_menu), (model.show_in_menu? ? :ok : :warn)
    end
  end

  def in_footer
    arbre do
      status_tag I18n.t(model.show_in_footer.to_s), (model.show_in_footer? ? :ok : :warn)
    end
  end

  private

  def background?
    model.background.present?
  end
end
