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
      value = !Rails.env.production? || Figaro.env.google_analytics_key.nil? || cookies[:cookie_cnil_cancel] == '1' || request.headers['HTTP_DNT'] == '1' || !@analytics_module.enabled?
      gon.push(disable_cookie_message: value)
      value
    end

    def cookie_cnil_check?
      !cookies[:cookiebar_cnil].nil?
    end
  end
end
