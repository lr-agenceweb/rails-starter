# frozen_string_literal: true

#
# Errors Controller
# ===================
class ErrorsController < ApplicationController
  include Skippable

  before_action :set_error_message
  decorates_assigned :error

  layout 'error'

  def show
    render status_code.to_s, status: status_code
  end

  private

  def set_error_message
    @locale = request.original_url.split('/')[3]
    @locale = I18n.default_locale if @locale.nil? || !I18n.available_locales.include?(@locale.to_sym)
    @status_code = status_code
  end

  def status_code
    params[:code] || 500
  end
end
