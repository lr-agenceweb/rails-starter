#
# == Setting Decorator
#
class SettingDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  delegate_all

  def credentials
    "#{setting.name} - Tous droits réservés <br> Copyright &copy; #{current_year} <br> #{about} #{admin_link}"
  end

  def map(force = false)
    raw content_tag(:div, nil, class: 'map dark', id: 'map') if model.show_map || force
  end

  private

  def about
    "About"
    # link_to I18n.t('main_menu.about'), abouts_path
  end

  def admin_link
    ' - ' + (link_to ' administration', admin_root_path, target: :blank) if current_user_and_administrator?
  end
end
