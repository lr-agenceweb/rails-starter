# frozen_string_literal: true

#
# == VideoSetting
#
puts 'Create video settings'
VideoSetting.create!(
  video_platform: true,
  video_upload: true,
  video_background: true
)
