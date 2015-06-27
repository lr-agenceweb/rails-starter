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
      status_tag I18n.t("enabled.#{model.show_in_menu}"), (model.show_in_menu? ? :ok : :warn)
    end
  end

  def in_footer
    arbre do
      status_tag I18n.t("enabled.#{model.show_in_footer}"), (model.show_in_footer? ? :ok : :warn)
    end
  end

  #
  # == Optional Modules
  #
  def module
    message = 'Module activé'
    color = 'blue'
    if !model.optional && model.optional_module_id.nil?
      message = 'Module de base'
      color = ''
    else
      if model.optional && !model.optional_module_enabled
        message = 'Module non activé'
        color = 'red'
      end
    end

    arbre do
      status_tag message, color
    end
  end

  private

  def background?
    model.background.present?
  end
end
