#
# == Errors Controller
#
class ErrorsController < ApplicationController
  skip_before_action :set_optional_modules, :set_adult_validation, :set_menu_elements, :set_background, :set_host_name, :set_newsletter_user, :set_search_autocomplete, :set_slider, :set_socials_network, :set_map
  before_action :set_error_message
  decorates_assigned :error

  layout 'error'

  def show
    render status_code.to_s, status: status_code
  end

  private

  def status_code
    params[:code] || 500
  end

  def set_error_message
    @locale = request.original_url.split('/')[3]
    @locale = I18n.default_locale if @locale.nil? || !I18n.available_locales.include?(@locale.to_sym)
    @status_code = status_code
  end
end
