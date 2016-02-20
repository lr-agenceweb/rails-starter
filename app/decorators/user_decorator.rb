#
# == UserDecorator
#
class UserDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  include AssetsHelper

  delegate_all
  decorates_association :posts

  def image_avatar(size = 64)
    retina_thumb_square(model, size)
  end

  def admin_link
    link_to I18n.t('active_admin.show'), admin_user_path(model)
  end

  #
  # == Omniauth
  #
  def link_to_facebook
    provider = 'facebook'
    if user.from_omniauth?
      link_to(
        fa_icon('facebook', text: I18n.t('omniauth.unlink.button', provider: 'Facebook')),
        user_omniauth_unlink_path(provider: provider),
        class: 'button omniauth facebook',
        id: 'omniauth_facebook',
        data: {
          vex_title: I18n.t('omniauth.title', provider: provider.capitalize),
          vex_message: I18n.t('omniauth.unlink.message', provider: provider.capitalize)
        }
      )
    else
      link_to(
        fa_icon('facebook', text: I18n.t('omniauth.link.button', provider: 'Facebook')),
        user_omniauth_authorize_path(provider: provider),
        class: 'button omniauth facebook',
        id: 'omniauth_facebook',
        data: {
          vex_title: I18n.t('omniauth.title', provider: provider.capitalize),
          vex_message: I18n.t('omniauth.link.message', provider: provider.capitalize)
        }
      )
    end
  end

  #
  # == Status tag
  #
  def status
    color = 'green'
    color = 'red' if model.administrator?
    color = 'blue' if model.super_administrator?

    status_tag_deco(I18n.t("role.#{model.role_name}"), color)
  end
end
