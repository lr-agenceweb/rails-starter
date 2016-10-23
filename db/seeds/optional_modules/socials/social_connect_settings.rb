# frozen_string_literal: true

#
# == SocialConnectSetting
#
puts 'Create SocialConnectSetting'
@social_connect_setting = SocialConnectSetting.create!(
  enabled: true
)
