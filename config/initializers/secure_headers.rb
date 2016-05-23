# frozen_string_literal: true

# See https://github.com/twitter/secureheaders#configuration
::SecureHeaders::Configuration.default do |config|
  config.hsts = "max-age=#{20.years.to_i}; includeSubdomains; preload"
  config.x_frame_options = 'SAMEORIGIN' # <frame>, <iframe> or <object>
  config.x_xss_protection = '1; mode=block'
  config.x_content_type_options = 'nosniff'
  config.x_download_options = SecureHeaders::OPT_OUT # disabled header
  config.x_permitted_cross_domain_policies = 'none'
  config.csp = SecureHeaders::OPT_OUT # disabled header
  config.hpkp = SecureHeaders::OPT_OUT # disabled header
end
