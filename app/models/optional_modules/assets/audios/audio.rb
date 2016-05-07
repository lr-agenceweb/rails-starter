# frozen_string_literal: true

# == Schema Information
#
# Table name: audios
#
#  id                 :integer          not null, primary key
#  audioable_id       :integer
#  audioable_type     :string(255)
#  audio_file_name    :string(255)
#  audio_content_type :string(255)
#  audio_file_size    :integer
#  audio_updated_at   :datetime
#  audio_autoplay     :boolean          default(FALSE)
#  online             :boolean          default(TRUE)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_audios_on_audioable_type_and_audioable_id  (audioable_type,audioable_id)
#

#
# == Audio Model
#
class Audio < ActiveRecord::Base
  include Assets::Attachable

  belongs_to :audioable, polymorphic: true, touch: true

  handle_attachment :audio,
                    styles: {
                      mp3audio: {
                        format: 'mp3'
                      },
                      oggaudio: {
                        format: 'ogg'
                      }
                    },
                    processors: [:transcoder]

  validates_attachment_size :audio, less_than: 5.megabytes
  validates_attachment_content_type :audio, content_type: ['audio/mpeg', 'audio/x-mpeg', 'audio/mp3', 'audio/x-mp3', 'audio/mpeg3', 'audio/x-mpeg3', 'audio/mpg', 'audio/x-mpg', 'audio/x-mpegaudio', 'audio/ogg', 'application/ogg']

  process_in_background :audio, processing_image_url: ActionController::Base.helpers.image_path('loader-dark.gif')

  scope :online, -> { where(online: true) }
end
