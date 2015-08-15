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
    retina_image_tag(model, :logo, :medium) if logo?
  end

  #
  # == Other
  #
  def credentials
    "#{setting.name} - #{copyright} <br> Copyright &copy; #{current_year} <br> #{about} #{admin_link}"
  end

  #
  # == Modules
  #
  def breadcrumb
    color = model.show_breadcrumb? ? 'blue' : 'red'
    status_tag_deco I18n.t("enabled.#{model.show_breadcrumb}"), color
  end

  def social
    color = model.show_social? ? 'blue' : 'red'
    status_tag_deco I18n.t("enabled.#{model.show_social}"), color
  end

  def maintenance
    color = model.maintenance? ? 'red' : 'green'
    status_tag_deco I18n.t("maintenance.#{model.maintenance}"), color
  end

  def newsletter(newsletter_user)
    content_tag(:div) do
      concat(content_tag(:span, I18n.t('newsletter.header'), class: 'header'))
      concat(render 'footer/newsletter_form', newsletter_user: newsletter_user)
    end
  end

  #
  # Microdatas
  #
  def microdata_meta(map)
    h.content_tag(:div, '', itemscope: '', itemtype: 'http://schema.org/ProfessionalService') do
      concat(tag(:meta, itemprop: 'logo', content: attachment_url(model.logo, :medium))) if logo?
      concat(tag(:meta, itemprop: 'url', content: root_url))
      concat(tag(:meta, itemprop: 'telephone', content: setting.phone))
      concat(tag(:meta, itemprop: 'email', content: setting.email))
      concat(tag(:meta, itemprop: 'name legalName', content: title_subtitle_inline))
      concat(map.microdata_meta)
    end
  end

  private

  def logo?
    model.logo.exists?
  end

  def subtitle?
    !model.subtitle.blank?
  end

  def about
    link_to I18n.t('main_menu.about'), abouts_path
  end

  def copyright
    I18n.t('footer.copyright')
  end

  def admin_link
    ' - ' + (link_to ' administration', admin_root_path, target: :blank) if current_user_and_administrator?
  end

  def small_subtitle
    content_tag(:small, model.subtitle, class: 'l-header-site-subtitle')
  end
end
