if Rails.env.staging? || Rails.env.production?
  Dkim::domain      = Figaro.env.application_domain_name
  Dkim::selector    = 'default'
  Dkim::private_key = File.read('config/dkim/dkim.private.key')

  # This will sign all ActionMailer deliveries
  ActionMailer::Base.register_interceptor(Dkim::Interceptor)
end