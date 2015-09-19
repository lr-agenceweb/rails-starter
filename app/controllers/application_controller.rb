#
# == ApplicationController
#
class ApplicationController < ActionController::Base
  include ApplicationHelper
  include SocialHelper
  include HtmlHelper
  include UserHelper

  protect_from_forgery with: :exception
  analytical modules: [:google], disable_if: proc { !Rails.env.production? || Figaro.env.google_analytics_key.nil? }

  before_action :setting_or_maintenance?
  before_action :set_optional_modules
  before_action :set_adult_validation, if: proc { @adult_module.enabled? && !cookies[:adult] }
  before_action :set_language
  before_action :set_menu_elements
  before_action :set_background, if: proc { @background_module.enabled && !@category.nil? }
  before_action :set_host_name
  before_action :set_newsletter_user, if: proc { @newsletter_module.enabled? }
  before_action :set_slider, if: proc { @slider_module.enabled? }
  before_action :set_socials_network, if: proc { @social_module.enabled? }
  before_action :set_map, if: proc { @map_module.enabled? }
  before_action :set_froala_key

  decorates_assigned :setting, :category, :slider, :map, :background, :menu

  private

  def setting_or_maintenance?
    @setting = Setting.first
    render template: 'elements/maintenance', layout: 'maintenance' if @setting.maintenance?
  end

  def set_language
    @language = I18n.locale
    gon.push(language: @language)
  end

  def set_menu_elements
    menu_elements = Menu.includes(:translations, :category).online.only_parents.with_page.with_allowed_modules
    @menu_elements_header ||= MenuDecorator.decorate_collection(menu_elements.visible_header.by_position)
    @menu_elements_footer ||= MenuDecorator.decorate_collection(menu_elements.visible_footer.by_position)
    @controller_name = controller_name.classify
    @category = Category.includes(menu: [:translations]).find_by(name: @controller_name)
  end

  def set_background
    @background = @category.background
  end

  def set_host_name
    @hostname = request.host
  end

  def set_newsletter_user
    @newsletter_user ||= NewsletterUser.new
  end

  def set_adult_validation
    gon.push(
      adult_validation: true,
      adult_not_validated_popup_content: StringBox.find_by(key: 'adult_not_validated_popup_content').content
    )
  end

  def set_slider
    @slider = Slider.includes(slides: [:translations]).online.by_page(controller_name.classify).first
  end

  def set_socials_network
    socials_all = Social.enabled
    @socials_follow = socials_all.follow
    @socials_share = socials_all.share
  end

  def set_map
    @map = Map.first
  end

  def set_optional_modules
    @optional_mod = OptionalModule.all
    @optional_mod.find_each do |optional_module|
      instance_variable_set("@#{optional_module.name.underscore.singularize}_module", optional_module)
    end
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
