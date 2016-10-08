# frozen_string_literal: true

#
# == Core namespace
#
module Core
  #
  # == LanguageHelper
  #
  module LanguageHelper
    def language_menu(element)
      language_menu_html = ''

      I18n.available_locales.each do |locale|
        locale = locale.to_s

        # get params to merge in url
        params_language = params_language(element, locale)

        # create link
        link = link_to_unless(current_locale?(locale),
                              I18n.t("active_admin.globalize.language.#{locale}"),
                              params.merge(params_language),
                              class: 'menu__item__link') do |item|
          current_link_language('check', item)
        end

        # wrap link in li tag
        language_menu_html += content_tag(:li, link, class: "menu__item #{active_language(locale)}")
      end
      raw language_menu_html
    end

    private

    def params_language(element, locale)
      if change_slug?
        return { locale: locale, blog_category_id: slug_for_locale(element.blog_category, locale), id: slug_for_locale(element, locale) } if element.is_a?(Blog)
        return { locale: locale, id: slug_for_locale(element, locale) }
      end

      { locale: locale }
    end

    def change_slug?
      (params[:controller] == 'abouts' ||
       params[:controller] == 'blogs' ||
       params[:controller] == 'events' ||
       params[:controller] == 'blog_categories'
      ) && params[:action] == 'show'
    end

    def slug_for_locale(element, locale)
      current_locale = I18n.locale
      I18n.locale = locale
      slug_locale = element.slug
      I18n.locale = current_locale
      slug_locale
    end

    def current_locale?(locale)
      params[:locale] == locale
    end

    def current_link_language(icon, text)
      link_to fa_icon(icon, text: text, right: true), '#', class: 'menu__item__link'
    end

    def active_language(locale)
      'menu__item__active' if current_locale?(locale)
    end
  end
end
