#
# == ApplicationController
#
class ApplicationController < ActionController::Base
  include ApplicationHelper
  include SocialHelper
  include HtmlHelper
  include UserHelper

  protect_from_forgery with: :exception
  analytical modules: [:google], disable_if: proc { !Rails.env.production? && Figaro.env.google_analytics_key.nil? }

  before_action :setting_or_maintenance?
  before_action :set_optional_modules
  before_action :set_adult_validation, if: proc { @adult_module.enabled? }
  before_action :set_language
  before_action :set_menu_elements
  before_action :set_background, unless: proc { @category.nil? }
  before_action :set_host_name
  before_action :set_newsletter_user, if: proc { @newsletter_module.enabled? }
  before_action :set_search_autocomplete, if: proc { @search_module.enabled? }

  decorates_assigned :setting, :category

  private

  def setting_or_maintenance?
    @setting = Setting.first
    render template: 'elements/maintenance', layout: 'maintenance' if @setting.maintenance?
  end

  def set_language
    @language = I18n.locale
    gon.push(
      language: @language,
      vex_yes_text: t('vex.yes'),
      vex_no_text: t('vex.no')
    )
  end

  def set_menu_elements
    menu_elements = ::Category.includes(:translations, :referencement).all
    @menu_elements_header ||= ::CategoryDecorator.decorate_collection(menu_elements.visible_header.with_allowed_module.by_position)
    @menu_elements_footer ||= ::CategoryDecorator.decorate_collection(menu_elements.visible_footer.with_allowed_module.by_position)
    @category = Category.find_by(name: controller_name.classify)
  end

  def set_background
    @background = Background.find_by(attachable_id: @category.id)
  end

  def set_host_name
    @hostname = request.host
  end

  def set_newsletter_user
    @newsletter_user ||= NewsletterUser.new
  end

  def set_search_autocomplete
    gon.push(search_path: searches_path(format: :json))
  end

  def set_adult_validation
    gon.push(
      adult_validation: true,
      adult_not_validated_popup_content: StringBox.find_by(key: 'adult_not_validated_popup_content').content
    )
  end

  def set_optional_modules
    OptionalModule.find_each do |optional_module|
      instance_variable_set("@#{optional_module.name.underscore.singularize}_module", optional_module)
    end
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
