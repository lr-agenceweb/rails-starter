#
# == ApplicationController
#
class ApplicationController < ActionController::Base
  include ApplicationHelper

  protect_from_forgery with: :exception
  analytical modules: [:google]

  before_action :set_language
  before_action :set_setting
  before_action :set_host_name

  private

  def set_language
    @language = I18n.locale
    gon.push(language: @language)
  end

  def set_setting
    @setting = Setting.first
  end

  def set_host_name
    @hostname = request.host
  end
end
