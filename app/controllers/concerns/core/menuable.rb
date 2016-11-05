# frozen_string_literal: true

#
# == Core namespace
#
module Core
  #
  # == MenuableConcern
  #
  module Menuable
    extend ActiveSupport::Concern

    included do
      before_action :set_menu_elements,
                    :set_controller_name,
                    :set_pages,
                    :set_current_page
      before_action :not_found,
                    unless: proc {
                      @page.nil? || @page.menu_online
                    }

      def set_menu_elements
        menu_elements = Menu.includes(:translations, :page).online.only_parents.with_page.with_allowed_modules
        @menu_elements_header ||= MenuDecorator.decorate_collection(menu_elements.visible_header.by_position)
        @menu_elements_footer ||= MenuDecorator.decorate_collection(menu_elements.visible_footer.by_position)
      end

      def set_controller_name
        @controller_name = controller_name.classify
        @controller_name = 'Blog' if @controller_name == 'BlogCategory'
      end

      def set_pages
        @pages = Page.includes(menu: [:translations]).all
      end

      def set_current_page
        @page = @pages.find_by(name: @controller_name)
      end
    end
  end
end
