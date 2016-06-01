# frozen_string_literal: true

# Staging configuration is identical to production, with some overrides
require_relative './production'

Rails.application.configure do
  config.action_mailer.default_url_options = {
    host: Figaro.env.application_domain_name_backup
  }
end
