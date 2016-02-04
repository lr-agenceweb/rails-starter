#
# == Setting Decorator
#
class SettingDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  include AssetsHelper

  delegate_all

  #
  # == Title / Subtitle
  #
  def title
    content_tag(:span, model.title)
  end

  def title_subtitle(header = :h1, link = root_path, klass = '')
    content_tag(:a, href: link, class: "l-header-site-title-link #{klass}") do
      concat(content_tag(header, class: 'l-header-site-title') do
        concat(title) + ' ' + concat(small_subtitle)
      end)
    end
  end

  def title_subtitle_inline
    "#{setting.title} #{setting.subtitle.downcase if subtitle?}"
  end

  #
  # == Logo
  #
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
  # == Other
  #
  def credentials
    "#{CGI.escapeHTML(setting.name)} - #{copyright} - Copyright &copy; #{current_year}"
  end

  def phone_w3c
    model.phone.delete(' ').remove('(0)')
  end

  #
  # == Modules
  #
  def map
    color = model.show_map? ? 'blue' : 'red'
    status_tag_deco I18n.t("enabled.#{model.show_map}"), color
  end

  def breadcrumb
    color = model.show_breadcrumb? ? 'blue' : 'red'
    status_tag_deco I18n.t("enabled.#{model.show_breadcrumb}"), color
  end

  def social
    color = model.show_social? ? 'blue' : 'red'
    status_tag_deco I18n.t("enabled.#{model.show_social}"), color
  end

  def qrcode
    color = model.show_qrcode? ? 'blue' : 'red'
    status_tag_deco I18n.t("enabled.#{model.show_qrcode}"), color
  end

  def maintenance
    color = model.maintenance? ? 'red' : 'green'
    status_tag_deco I18n.t("maintenance.#{model.maintenance}"), color
  end

  def newsletter(newsletter_user)
    content_tag(:div, class: 'newsletter-form') do
      concat(content_tag(:span, I18n.t('newsletter.header'), class: 'newsletter-form-header'))
      concat(render 'footer/newsletter_form', newsletter_user: newsletter_user)
    end
  end

  def about
    link_to I18n.t('main_menu.about'), abouts_path
  end

  def admin_link
    ' - ' + (link_to ' administration', admin_root_path, target: :blank) if current_user_and_administrator?
  end

  private

  def logo?
    model.logo.exists?
  end

  def logo_footer?
    model.logo_footer.exists?
  end

  def subtitle?
    !model.subtitle.blank?
  end

  def copyright
    I18n.t('footer.copyright')
  end

  def small_subtitle
    content_tag(:small, model.subtitle, class: 'l-header-site-subtitle')
  end
end
