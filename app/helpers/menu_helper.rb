# == MenuHelper
#
# This file contain helpfull methods for menu
#
module MenuHelper
  def controller?(*controller)
    controller.include?(params[:controller])
  end

  def action?(*action)
    action.include?(params[:action])
  end

  def set_active_class(controller, action = false)
    if action == false
      'l-nav-item-active' if controller?(controller)
    else
      'l-nav-item-active' if controller?(controller) && action?(action)
    end
  end

  def show_path_for_object(object)
    case object.class.name
    when 'Home'
      return root_path
    when 'Contact'
      return new_contact_path(object)
    else
      return '#'
    end
  end

  # Language
  def current_locale?(locale)
    params[:locale] == locale
  end

  def active_language(locale)
    'l-nav-item-active' if current_locale?(locale)
  end

  def current_link_language(icon, text)
    link_to fa_icon(icon, text: text, right: true), '#', class: 'l-nav-item-link'
  end
end
