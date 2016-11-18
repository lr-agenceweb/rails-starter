# frozen_string_literal: true

#
# Setting Decorator
# ===================
class SettingDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  include AssetsHelper

  delegate_all

  #
  # Title / Subtitle
  # ==================
  def title
    safe_join [raw(model.title)]
  end

  def title_and_subtitle
    html = []
    html << title
    html << subtitle if subtitle?
    safe_join [html], ', '
  end

  #
  # Logo
  # ======
  def logo_deco
    # Website logo present
    retina_image_tag(model, :logo, :medium, class: 'text-center') if logo?
  end

  def logo_footer_site
    return retina_image_tag(model, :logo_footer, :medium) if logo_footer?
    return model.title unless logo?
    logo_deco
  end

  #
  # Contact informations
  # ======================
  def email
    h.fa_icon('envelope', text: mail_to(model.email, model.email, class: 'email__link'))
  end

  def phone
    return unless phone?
    link_phone = link_to(model.phone, "tel:#{phone_w3c}", class: 'phone__link')
    h.fa_icon('phone', text: link_phone)
  end

  def phone_w3c
    model.phone.delete(' ').remove('(0)') if phone?
  end

  #
  # Date format
  # =============
  def date_format_i18n
    content_tag(:span, t("enum.setting.date_formats.#{model.date_format}"), class: "status_tag #{model.date_format}")
  end

  #
  # Other
  # =======
  def about
    link_to I18n.t('main_menu.about'), abouts_path
  end

  def credentials
    html = []
    html << setting.name
    html << I18n.t('footer.copyright')
    html << "Copyright \u00A9 #{current_year}" # \u00A9 => &copy;
    safe_join [html], ' - '
  end

  def admin_link
    html = []
    html << ' -'
    html << link_to('administration', admin_root_path, target: :_blank)
    safe_join [html], ' ' if current_user_and_administrator?
  end
end
