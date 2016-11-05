# frozen_string_literal: true

#
# == OptionalModules namespace
#
module OptionalModules
  #
  # == AnalyticableConcern
  #
  module Analyticable
    extend ActiveSupport::Concern

    included do
      analytical modules: [:google], disable_if: proc { |controller| controller.analytical_modules? || !controller.cookie_cnil_check? }
    end

    def analytical_modules?
      @bool_value = !Rails.env.production? || Figaro.env.google_analytics_key.nil? || cookies[:cookie_cnil_cancel] == '1' || request.headers['HTTP_DNT'] == '1' || !@analytics_module.enabled?
      @bool_value
    ensure
      send_gonalytical
    end

    def cookie_cnil_check?
      !cookies[:cookiebar_cnil].nil?
    end

    def send_gonalytical
      cookies_template = @bool_value ? false : render_to_string(partial: 'elements/cookies_template')
      gon.push(
        disable_cookie_message: @bool_value,
        cookies_template: cookies_template
      )
    end
  end
end
