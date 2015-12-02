# == Schema Information
#
# Table name: video_settings
#
#  id               :integer          not null, primary key
#  video_platform   :boolean          default(TRUE)
#  video_upload     :boolean          default(TRUE)
#  video_background :boolean          default(FALSE)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

#
# == VideoSetting Model
#
class VideoSetting < ActiveRecord::Base
end
