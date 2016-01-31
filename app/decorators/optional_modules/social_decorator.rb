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

  def ikon_deco(size = '')
    if ikon?
      retina_image_tag model, :ikon, :small
    elsif font_ikon?
      fa_icon "#{model.font_ikon} #{size}"
    else
      model.title
    end
  end

  def kind
    I18n.t("social.#{model.kind}")
  end

  def link
    link_to model.link, model.link, target: :blank if link?
  end

  def hint_by_ikon
    if ikon?
      "Ce champs est désactivé car vous avez choisi d'utiliser une image en guise d'icône"
    else
      raw "Si vous ne choisissez aucune image ou icône (#{font_ikon_list}), le titre du réseau social sera utilisé."
    end
  end

  def ikon?
    model.ikon.present? && model.ikon.exists?
  end

  private

  def font_ikon_list
    Social.allowed_font_awesome_ikons.map { |ikon| fa_icon(ikon, title: ikon) }.join(', ')
  end

  def font_ikon?
    !model.font_ikon.blank?
  end

  def link?
    !model.link.blank?
  end
end
