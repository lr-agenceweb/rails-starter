# frozen_string_literal: true
# == Schema Information
#
# Table name: video_platforms
#
#  id                  :integer          not null, primary key
#  videoable_id        :integer
#  videoable_type      :string(255)
#  url                 :string(255)
#  native_informations :boolean          default(FALSE)
#  online              :boolean          default(TRUE)
#  position            :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_video_platforms_on_videoable_type_and_videoable_id  (videoable_type,videoable_id)
#

#
# == VideoPlatform Model
#
class VideoPlatform < ActiveRecord::Base
  translates :title, :description, fallbacks_for_empty_translations: true
  active_admin_translates :title, :description

  belongs_to :videoable, polymorphic: true, touch: true

  validates :url, allow_blank: false, presence: true, url: true

  scope :online, -> { where(online: true) }
end
