if Rails.env.staging? || Rails.env.production?
  Dkim.domain      = ENV["application_domain_name_#{Rails.env}"].sub(/www\.|www2\./, '')
  Dkim.selector    = 'default'
  Dkim.private_key = File.read('config/dkim/dkim.private.key')

  # This will sign all ActionMailer deliveries
  ActionMailer::Base.register_interceptor(Dkim::Interceptor)
end
