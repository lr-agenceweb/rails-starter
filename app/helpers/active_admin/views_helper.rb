# frozen_string_literal: true

#
# == ActiveAdmin namespace
#
module ActiveAdmin
  #
  # == Views helper
  #
  module ViewsHelper
    def edit_heading_page_aa
      category = Category.find_by(name: controller_name.classify)
      link_to t('active_admin.action_item.edit_heading_page', page: category.menu_title).html_safe, edit_admin_category_path(category)
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
