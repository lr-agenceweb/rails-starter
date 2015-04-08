#
# == MenuHelper
#
module MenuHelper
  def set_active_class(controller, action = false)
    if action == false
      'l-nav-item-active' if controller?(controller)
    else
      'l-nav-item-active' if controller?(controller) && action?(action)
    end
  end

  private

  def controller?(*controller)
    controller.include?(params[:controller])
  end

  def action?(*action)
    action.include?(params[:action])
  end
end
