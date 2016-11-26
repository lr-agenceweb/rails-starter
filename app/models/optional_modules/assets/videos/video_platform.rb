# frozen_string_literal: true

#
# VideoPlatform Model
# =====================
class VideoPlatform < ApplicationRecord
  # Translations
  translates :title, :description, fallbacks_for_empty_translations: true
  active_admin_translates :title, :description

  # Model relations
  belongs_to :videoable, polymorphic: true, touch: true

  # Validation rules
  validates :url,
            presence: true,
            allow_blank: false,
            url: true

  # Scopes
  scope :online, -> { where(online: true) }
end

# == Schema Information
#
# Table name: video_platforms
#
#  id                  :integer          not null, primary key
#  videoable_type      :string(255)
#  videoable_id        :integer
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
