# frozen_string_literal: true

# == Schema Information
#
# Table name: video_settings
#
#  id                 :integer          not null, primary key
#  video_platform     :boolean          default(TRUE)
#  video_upload       :boolean          default(TRUE)
#  video_background   :boolean          default(FALSE)
#  turn_off_the_light :boolean          default(TRUE)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

#
# VideoSetting Model
# ======================
class VideoSetting < ApplicationRecord
end
