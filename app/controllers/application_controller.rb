#
# == ApplicationController
#
class ApplicationController < ActionController::Base
  include ApplicationHelper

  protect_from_forgery with: :exception
  analytical modules: [:google]

  before_action :set_language
  before_action :set_setting
  before_action :set_menu_elements
  before_action :set_host_name

  decorates_assigned :setting

  private

  def set_language
    @language = I18n.locale
    gon.push(language: @language)
  end

  def set_setting
    @setting = Setting.first
  end

  def set_menu_elements
    menu_elements = Category.all
    @menu_elements_header ||= ::CategoryDecorator.decorate_collection(menu_elements.visible_header)
    @menu_elements_footer ||= ::CategoryDecorator.decorate_collection(menu_elements.visible_footer)
    @category = Category.find_by(name: controller_name.classify)
  end

  def set_host_name
    @hostname = request.host
  end
end
