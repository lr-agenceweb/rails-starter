# frozen_string_literal: true

#
# == SocialProviders
#
puts 'Create SocialProvider'
SocialProvider.allowed_social_providers.each do |provider|
  puts "Create SocialProvider #{provider}"
  SocialProvider.create!(
    name: provider,
    enabled: true,
    social_connect_setting_id: @social_connect_setting.id
  )
end
