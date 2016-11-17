# frozen_string_literal: true

#
# UserDecorator
# ===============
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
  # ActiveAdmin
  # =============
  def active_admin_header_user_profile
    html = []
    html << retina_thumb_square(model)
    html << content_tag(:span) do
      concat model.username.capitalize
      concat " (#{I18n.t('role.' + model.role_name)})"
      concat tag(:br)
      concat connected_from
    end
    safe_join [html], ' '
  end

  def connected_from
    t('user.connected_from', from: provider.blank? ? 'site' : provider)
  end

  #
  # Omniauth
  # ===========
  %w(facebook twitter google).each do |provider|
    define_method "link_to_#{provider}" do
      if user.from_omniauth? provider
        link_to(
          h.fa_icon(provider, text: I18n.t('omniauth.unlink.button', provider: provider.capitalize)),
          user_omniauth_unlink_path(provider: provider, id: model.id),
          method: :delete,
          class: "button omniauth #{provider}",
          id: "omniauth_#{provider}",
          data: {
            vex_title: I18n.t('omniauth.title', provider: provider.capitalize),
            vex_message: I18n.t('omniauth.unlink.message', provider: provider.capitalize)
          }
        )
      else
        provider_name = provider == 'google' ? 'google_oauth2' : provider
        link_to(
          h.fa_icon(provider, text: I18n.t('omniauth.link.button', provider: provider.capitalize)),
          send("user_#{provider_name}_omniauth_authorize_path"),
          class: "button omniauth #{provider}",
          id: "omniauth_#{provider}",
          data: {
            vex_title: I18n.t('omniauth.title', provider: provider.capitalize),
            vex_message: I18n.t('omniauth.link.message', provider: provider.capitalize)
          }
        )
      end
    end
  end

  #
  # Status tag
  # ============
  def status
    color = 'green'
    color = 'red' if model.administrator?
    color = 'blue' if model.super_administrator?

    status_tag_deco(I18n.t("role.#{model.role_name}"), color)
  end
end
