#
# == MenuHelper
#
module MenuHelper
  def set_active_class(controller, action = false)
    if action == false
      'active' if controller?(controller)
    else
      'active' if controller?(controller) && action?(action)
    end
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
end
