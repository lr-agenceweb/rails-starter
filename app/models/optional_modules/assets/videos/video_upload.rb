# frozen_string_literal: true
# == Schema Information
#
# Table name: video_uploads
#
#  id                      :integer          not null, primary key
#  videoable_id            :integer
#  videoable_type          :string(255)
#  online                  :boolean          default(TRUE)
#  position                :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  video_file_file_name    :string(255)
#  video_file_content_type :string(255)
#  video_file_file_size    :integer
#  video_file_updated_at   :datetime
#  video_file_processing   :boolean
#  retina_dimensions       :text(65535)
#  video_autoplay          :boolean          default(FALSE)
#  video_loop              :boolean          default(FALSE)
#  video_controls          :boolean          default(TRUE)
#  video_mute              :boolean          default(FALSE)
#
# Indexes
#
#  index_video_uploads_on_videoable_type_and_videoable_id  (videoable_type,videoable_id)
#

#
# == VideoUpload Model
#
class VideoUpload < ActiveRecord::Base
  include Assets::Attachable

  translates :title, :description, fallbacks_for_empty_translations: true
  active_admin_translates :title, :description

  belongs_to :videoable, polymorphic: true, touch: true

  has_one :video_subtitle, as: :subtitleable, dependent: :destroy
  accepts_nested_attributes_for :video_subtitle, reject_if: :all_blank, allow_destroy: true

  handle_attachment :video_file,
                    styles: {
                      mp4video: {
                        geometry: '1280x720',
                        format: 'mp4'
                      },
                      oggvideo: {
                        geometry: '1280x720',
                        format: 'ogg'
                      },
                      webmvideo: {
                        geometry: '1280x720',
                        format: 'webm'
                      },
                      preview_large: {
                        geometry: '1920x1080#',
                        format: 'jpg',
                        time: 2
                      },
                      preview: {
                        geometry: '380x240#',
                        format: 'jpg',
                        time: 1
                      }
                    },
                    processors: [:transcoder]

  validates_attachment_content_type :video_file, content_type: %r{\Avideo\/.*\Z}
  validates_attachment_size :video_file, in: 0.megabytes..100.megabytes
  process_in_background :video_file, processing_image_url: ActionController::Base.helpers.image_path('loader-dark.gif')

  delegate :online, to: :video_subtitle, prefix: true, allow_nil: true

  scope :online, -> { where(online: true) }
  scope :not_processing, -> { where.not(video_file_processing: true) }
end
