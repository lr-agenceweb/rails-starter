# frozen_string_literal: true

# Staging configuration is identical to production, with some overrides
require_relative './production'

Rails.application.configure do
  # Controller
  config.action_controller.asset_host = Figaro.env.application_host

  # Mailer
  config.action_mailer.default_url_options = {
    host: Figaro.env.application_domain_name
  }
  config.action_mailer.asset_host = Figaro.env.application_host

  # ActionCable (WebSockets)
  config.action_cable.url = "ws://#{Figaro.env.application_domain_name}/cable"

  # Restrict access to the staging environment
  config.middleware.insert_before(::Rack::Runtime, '::Rack::Auth::Basic', 'Staging environment') do |u, p|
    (u == Figaro.env.admin_username && p == Figaro.env.admin_password) ||
      (u == Figaro.env.guest_username && p == Figaro.env.guest_password)
  end
end

# Set host to links in staging environment
Rails.application.routes.default_url_options = {
  host: Figaro.env.application_host
}
