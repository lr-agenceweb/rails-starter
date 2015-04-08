#
# == LanguageHelper
#
module LanguageHelper
  def active_language(locale)
    'l-nav-item-active' if current_locale?(locale)
  end

  def current_link_language(icon, text)
    link_to fa_icon(icon, text: text, right: true), '#', class: 'l-nav-item-link'
  end

  private

  def current_locale?(locale)
    params[:locale] == locale
  end
end
