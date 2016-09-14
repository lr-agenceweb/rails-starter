# frozen_string_literal: true

#
# == ApplicationController
#
class ApplicationController < ActionController::Base
  include ApplicationHelper
  include OptionalModules::SocialHelper
  include HtmlHelper
  include UserHelper
  include AdminBarHelper

  protect_from_forgery with: :exception
  analytical modules: [:google], disable_if: proc { |controller| controller.analytical_modules? || !controller.cookie_cnil_check? }

  before_action :set_setting_or_maintenance
  before_action :set_legal_notices

  # Core
  include Core::Languageable
  include Core::Menuable

  # Optional modules
  include OptionalModules::OptionalModulable
  include OptionalModules::Adultable
  include OptionalModules::AdminBarable
  include OptionalModules::Socialable
  include OptionalModules::Backgroundable
  include OptionalModules::Mappable
  include OptionalModules::Sliderable
  include OptionalModules::Videoable
  include OptionalModules::NewsletterFrontUserable

  # Security
  include Security::NotificationSettings

  # Misc
  before_action :set_host_name
  before_action :set_froala_key, if: :user_signed_in?

  decorates_assigned :setting, :category, :menu

  def analytical_modules?
    value = !Rails.env.production? || Figaro.env.google_analytics_key.nil? || cookies[:cookie_cnil_cancel] == '1' || request.headers['HTTP_DNT'] == '1'
    gon.push(disable_cookie_message: value)
    value
  end

  def cookie_cnil_check?
    !cookies[:cookiebar_cnil].nil?
  end

  def not_found
    raise ActionController::RoutingError, 'Not Found'
  end

  private

  def set_setting_or_maintenance
    @setting = Setting.first
    gon.push(
      site_title: @setting.title,
      root_url: root_url,
      date_format: @setting.date_format
    )

    render template: 'maintenance/maintenance', layout: 'maintenance', status: 503 if maintenance? && !current_user_and_administrator?
  end

  def set_legal_notices
    @legal_notice_category = Category.includes(menu: [:translations]).find_by(name: 'LegalNotice')
  end

  def set_host_name
    @hostname = request.host
  end

  def set_froala_key
    gon.push(froala_key: Figaro.env.froala_key)
  end

  def authenticate_active_admin_user!
    authenticate_user!
    redirect_to root_path unless current_user.super_administrator? || current_user.administrator? || current_user.subscriber?
  end

  def access_denied(exception)
    redirect_to admin_dashboard_path, alert: exception.message
  end
end
