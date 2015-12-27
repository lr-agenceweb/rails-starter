#
# == ApplicationController
#
class ApplicationController < ActionController::Base
  include ApplicationHelper
  include SocialHelper
  include HtmlHelper
  include UserHelper

  protect_from_forgery with: :exception
  analytical modules: [:google], disable_if: proc { |controller| controller.analytical_modules? || !controller.cookie_cnil_check? || request.headers['HTTP_DNT'] == '1' }

  before_action :set_setting_or_maintenance
  before_action :set_legal_notices

  # Core
  include Languageable
  include Menuable

  # Optional modules
  include OptionalModulable
  include Adultable
  include Socialable
  include Backgroundable
  include Mappable
  include Sliderable
  include Videoable
  include NewsletterFrontUserable

  # Misc
  before_action :set_host_name
  before_action :set_froala_key

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
    fail ActionController::RoutingError, 'Not Found'
  end

  private

  def set_setting_or_maintenance
    @setting = Setting.first
    gon.push(
      site_title: @setting.title,
      root_url: root_url
    )

    render template: 'elements/maintenance', layout: 'maintenance' if maintenance? && !current_user_and_administrator?
  end

  def set_legal_notices
    @legal_notice_category = Category.find_by(name: 'LegalNotice')
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
