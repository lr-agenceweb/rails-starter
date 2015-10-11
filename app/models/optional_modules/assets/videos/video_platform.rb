# == Schema Information
#
# Table name: video_platforms
#
#  id             :integer          not null, primary key
#  videoable_id   :integer
#  videoable_type :string(255)
#  url            :string(255)
#  online         :boolean          default(TRUE)
#  position       :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_video_platforms_on_videoable_type_and_videoable_id  (videoable_type,videoable_id)
#

#
# == VideoPlatform Model
#
class VideoPlatform < ActiveRecord::Base
  belongs_to :videoable, polymorphic: true

  validates :url, allow_blank: false, presence: true, url: true

  scope :online, -> { where(online: true) }
end
