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
  before_action :set_setting_or_maintenance

  # Core
  include Core::Languageable
  include Core::Menuable

  # Optional modules
  include OptionalModules::OptionalModulable
  include OptionalModules::AdminBarable
  include OptionalModules::Analyticable
  include OptionalModules::Adultable
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
  before_action :set_legal_notices

  decorates_assigned :setting, :category, :menu

  def not_found
    raise ActionController::RoutingError, 'Not Found'
  end

  private

  def set_setting_or_maintenance
    @setting = Setting.first
    gon.push(
      site_title: @setting.title,
      root_url: root_url,
      date_format: @setting.date_format,
      picture_in_picture: @setting.picture_in_picture
    )

    render template: 'maintenance/maintenance', layout: 'maintenance', status: 503 if maintenance? && !current_user_and_administrator?
  end

  def set_legal_notices
    @legal_notice_category = @categories.find_by(name: 'LegalNotice')
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
