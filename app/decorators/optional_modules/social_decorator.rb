#
# == SocialDecorator
#
class SocialDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  delegate_all

  def status
    color = model.enabled? ? 'green' : 'red'
    status_tag_deco(I18n.t("enabled.#{model.enabled}"), color)
  end

  def ikon_deco
    if ikon?
      retina_image_tag model, :ikon, :small
    else
      'Pas d\'icône'
    end
  end

  def link
    link_to model.link, model.link, target: :_blank
  end

  private

  def ikon?
    model.ikon.exists?
  end
end
