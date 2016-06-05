# frozen_string_literal: true

# Staging configuration is identical to production, with some overrides
require_relative './production'

Rails.application.configure do
  config.action_mailer.default_url_options = {
    host: Figaro.env.application_domain_name_staging
  }

  config.action_controller.asset_host = Figaro.env.application_host_staging
  config.action_mailer.asset_host = Figaro.env.application_host_staging

  # RESTRICTING ACCESS TO THE STAGE ENVIRONMENT
  config.middleware.insert_before(::Rack::Runtime, '::Rack::Auth::Basic', 'Staging environment') do |u, p|
    (u == Figaro.env.admin_username && p == Figaro.env.admin_password) ||
      (u == Figaro.env.guest_username && p == Figaro.env.guest_password)
  end
end
