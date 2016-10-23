# frozen_string_literal: true

#
# == VideoSetting
#
puts 'Creating VideoSetting'
VideoSetting.create!(
  video_platform: true,
  video_upload: true,
  video_background: true
)
