#
# == AdultSettingDecorator
#
class AdultSettingDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  delegate_all

  def title_d
    model.title if title?
  end

  def content_d
    raw(model.content) if content?
  end

  def status
    color = model.enabled? ? 'green' : 'red'
    status_tag_deco(I18n.t("enabled.#{model.enabled}"), color)
  end

  def redirect_link_d
    return Figaro.env.adult_not_validated_popup_redirect_link if model.redirect_link.blank?
    model.redirect_link
  end
end
