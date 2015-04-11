#
# == ApplicationController
#
class ApplicationController < ActionController::Base
  include ApplicationHelper
  include SocialHelper
  include HtmlHelper

  protect_from_forgery with: :exception
  analytical modules: [:google]

  before_action :set_language
  before_action :set_setting
  before_action :set_menu_elements
  before_action :set_host_name

  decorates_assigned :setting, :category

  private

  def set_language
    @language = I18n.locale
    gon.push(language: @language)
  end

  def set_setting
    @setting = Setting.first
  end

  def set_menu_elements
    menu_elements = ::Category.all
    @menu_elements_header ||= ::CategoryDecorator.decorate_collection(menu_elements.visible_header.by_position)
    @menu_elements_footer ||= ::CategoryDecorator.decorate_collection(menu_elements.visible_footer)
    @category = Category.find_by(name: controller_name.classify)
  end

  def set_host_name
    @hostname = request.host
  end

  def authenticate_active_admin_user!
    authenticate_user!
    redirect_to root_path unless current_user.super_administrator? || current_user.administrator? || current_user.subscriber?
  end

  def access_denied(exception)
    if current_user.subscriber?
      redirect_to admin_user_path(current_user), alert: exception.message
    else
      redirect_to admin_root_path, alert: exception.message
    end
  end
end
