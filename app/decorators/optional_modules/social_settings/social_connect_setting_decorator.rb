#
# == SocialConnectSettingDecorator
#
class SocialConnectSettingDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  delegate_all

  #
  # == ActiveAdmin
  #
  def title_aa_show
    I18n.t('activerecord.models.social_connect_setting.one')
  end

  #
  # == Status tag
  #
  def status
    color = model.enabled? ? 'green' : 'red'
    status_tag_deco(I18n.t("enabled.#{model.enabled}"), color)
  end
end
