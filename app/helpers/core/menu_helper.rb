# frozen_string_literal: true
#
# == Core namespace
#
module Core
  #
  # == MenuHelper
  #
  module MenuHelper
    def set_active_class(controller, action = false)
      'active' if (action == false && controller?(controller)) || (controller?(controller) && action?(action))
    end

    def even_or_odd_menu_item(items)
      items.length.odd? ? 'odd' : 'even'
    end

    private

    def controller?(*controller)
      controller.include?(params[:controller])
    end

    def action?(*action)
      action.include?(params[:action])
    end

    def nested_dropdown(items)
      result = []
      items.map do |item, sub_items|
        result << [(' - ' * item.depth) + item.title, item.id]
        result += nested_dropdown(sub_items) unless sub_items.blank?
      end
      result
    end
  end
end
