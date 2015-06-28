#
# == Setting Decorator
#
class SettingDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  delegate_all

  def title_subtitle(header = :h1, link = root_path, klass = '')
    content_tag(:a, href: link, class: "l-header-site-title-link #{klass}") do
      concat(content_tag(header, class: 'l-header-site-title') do
        concat(model.title) + concat(subtitle)
      end)
    end
  end

  def full_address
    simple_format("#{model.address} <br> #{model.postcode} - #{model.city}")
  end

  def latlon
    simple_format("#{model.latitude}, #{model.longitude}")
  end

  def credentials
    "#{setting.name} - #{copyright} <br> Copyright &copy; #{current_year} <br> #{about} #{admin_link}"
  end

  def map(force = false)
    raw content_tag(:div, nil, class: 'map dark', id: 'map') if model.show_map || force
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
    status I18n.t("enabled.#{model.show_breadcrumb}"), color
  end

  def social
    color = model.show_social? ? 'blue' : 'red'
    status I18n.t("enabled.#{model.show_social}"), color
  end

  def map_status
    color = model.show_map? ? 'blue' : 'red'
    status I18n.t("enabled.#{model.show_map}"), color
  end

  private

  def status(value, color)
    arbre do
      status_tag(value, color)
    end
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

  def subtitle
    content_tag(:small, model.subtitle, class: 'l-header-site-subtitle')
  end
end
