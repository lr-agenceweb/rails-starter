#
# == Setting Decorator
#
class SettingDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  include AssetsHelper

  delegate_all

  def title_subtitle(header = :h1, link = root_path, klass = '')
    content_tag(:a, href: link, class: "l-header-site-title-link #{klass}") do
      concat(content_tag(header, class: 'l-header-site-title') do
        concat(model.title) + ' ' + concat(small_subtitle)
      end)
    end
  end

  def logo_deco
    # Website logo present
    h.retina_image_tag(model, :logo, :medium) if logo?
  end

  def credentials
    "#{setting.name} - #{copyright} <br> Copyright &copy; #{current_year} <br> #{about} #{admin_link}"
  end

  def newsletter(newsletter_user)
    content_tag(:div) do
      concat(content_tag(:span, I18n.t('newsletter.header'), class: 'header'))
      concat(render 'footer/newsletter_form', newsletter_user: newsletter_user)
    end
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

  private

  def logo?
    model.logo.exists?
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
