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
      before_action :set_menu_elements
      before_action :set_controller_name
      before_action :set_categories
      before_action :set_current_category
      before_action :not_found, unless: proc { @category.nil? || @category.menu_online }

      def set_menu_elements
        menu_elements = Menu.includes(:translations, :category).online.only_parents.with_page.with_allowed_modules
        @menu_elements_header ||= MenuDecorator.decorate_collection(menu_elements.visible_header.by_position)
        @menu_elements_footer ||= MenuDecorator.decorate_collection(menu_elements.visible_footer.by_position)
      end

      def set_controller_name
        @controller_name = controller_name.classify
        @controller_name = 'Blog' if @controller_name == 'BlogCategory'
      end

      def set_categories
        @categories = Category.includes(menu: [:translations]).all
      end

      def set_current_category
        @category = @categories.find_by(name: @controller_name)
      end
    end
  end
end
