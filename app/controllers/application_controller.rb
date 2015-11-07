#
# == ApplicationController
#
class ApplicationController < ActionController::Base
  include ApplicationHelper
  include SocialHelper
  include HtmlHelper
  include UserHelper

  protect_from_forgery with: :exception
  analytical modules: [:google], disable_if: proc { |controller| controller.analytical_modules? }

  before_action :setting_or_maintenance?

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
  include NewsletterUserable

  # Misc
  before_action :set_host_name
  before_action :set_froala_key

  decorates_assigned :setting, :category, :menu

  def analytical_modules?
    value = !Rails.env.production? || Figaro.env.google_analytics_key.nil? || cookies[:cookie_cnil_cancel] === '1'
    gon.push(disable_cookie_message: value)
    value
  end

  private

  def setting_or_maintenance?
    @setting = Setting.first
    gon.push(
      site_title: @setting.title,
      root_url: root_url
    )
    render template: 'elements/maintenance', layout: 'maintenance' if @setting.maintenance?
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

  def not_found
    fail ActionController::RoutingError, 'Not Found'
  end
end
