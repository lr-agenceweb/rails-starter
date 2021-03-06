# frozen_string_literal: true
if Rails.env.staging? || Rails.env.production?
  Dkim.domain = Figaro.env.domain_name.gsub(/www\.|www2\./, '')
  Dkim.selector = 'default'
  Dkim.private_key = File.read('config/dkim/dkim.private.key')

  # This will sign all ActionMailer deliveries
  ActionMailer::Base.register_interceptor(Dkim::Interceptor)
end
