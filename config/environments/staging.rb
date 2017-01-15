# frozen_string_literal: true

# Staging configuration is identical to production, with some overrides
require_relative './production'

Rails.application.configure do
  # Restrict access to the staging environment
  config.middleware.insert_before(::Rack::Runtime, '::Rack::Auth::Basic', 'Staging environment') do |u, p|
    (u == Figaro.env.admin_username && p == Figaro.env.admin_password) ||
      (u == Figaro.env.guest_username && p == Figaro.env.guest_password)
  end
end
