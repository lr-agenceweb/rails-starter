# frozen_string_literal: true

#
# == ActiveAdmin namespace
#
module ActiveAdmin
  #
  # == Views helper
  #
  module ViewsHelper
    def action_item_page(name = '', title = 'heading')
      query = name.blank? ? controller_name.classify : name
      page = ::Page.includes(menu: [:translations]).find_by(name: query)
      link_to t("active_admin.action_item.edit_#{title}", page: page.menu_title).html_safe, edit_admin_page_path(page, section: title, anchor: title), target: :_blank
    end

    # Method used to allow caching show action
    def arbre_cache(context, *args)
      if controller.perform_caching
        if Rails.cache.exist?(*args)
          context.instance_eval do
            div(Rails.cache.read(*args))
          end
        else
          Rails.cache.write(*args, yield.to_s)
        end
      else
        yield
      end
    end
  end
end
