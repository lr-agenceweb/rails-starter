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

  def social_facebook
    provider = social_providers.find_by(name: 'facebook')
    social_provider_base(provider)
  end

  def social_twitter
    provider = social_providers.find_by(name: 'twitter')
    social_provider_base(provider)
  end

  def social_google_oauth2
    provider = social_providers.find_by(name: 'google')
    social_provider_base(provider)
  end

  private

  def social_provider_base(provider)
    color = provider.try(:enabled?) ? 'green' : 'red'
    status_tag_deco(I18n.t("enabled.#{provider.try(:enabled)}"), color)
  end
end
