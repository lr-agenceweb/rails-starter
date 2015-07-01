#
# == ApplicationController
#
class ApplicationController < ActionController::Base
  include ApplicationHelper
  include SocialHelper
  include HtmlHelper
  include UserHelper

  protect_from_forgery with: :exception
  analytical modules: [:google]

  before_action :set_setting
  before_action :maintenance?
  before_action :set_language
  before_action :set_menu_elements
  before_action :set_optional_modules
  before_action :set_background, unless: proc { @category.nil? }
  before_action :set_host_name
  before_action :set_newsletter_user, if: proc { @newsletter_module.enabled? }

  decorates_assigned :setting, :category

  private

  def maintenance?
    render template: 'elements/maintenance', layout: 'maintenance' if @setting.maintenance?
  end

  def set_language
    @language = I18n.locale
    gon.push(language: @language)
  end

  def set_setting
    @setting = Setting.first
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

  def set_optional_modules
    optional_modules = OptionalModule.all
    @rss_module = optional_modules.by_name('RSS')
    @newsletter_module = optional_modules.by_name('Newsletter')
    @comment_module = optional_modules.by_name('Comment')
    @blog_module = optional_modules.by_name('Blog')
  end

  def authenticate_active_admin_user!
    authenticate_user!
    redirect_to root_path unless current_user.super_administrator? || current_user.administrator? || current_user.subscriber?
  end

  def access_denied(exception)
    redirect_to admin_dashboard_path, alert: exception.message
  end
end
