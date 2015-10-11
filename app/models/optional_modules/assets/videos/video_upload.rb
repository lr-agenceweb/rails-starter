# == Schema Information
#
# Table name: video_uploads
#
#  id                 :integer          not null, primary key
#  videoable_id       :integer
#  videoable_type     :string(255)
#  online             :boolean          default(TRUE)
#  position           :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  video_file_name    :string(255)
#  video_content_type :string(255)
#  video_file_size    :integer
#  video_updated_at   :datetime
#  video_processing   :boolean
#  retina_dimensions  :text(65535)
#
# Indexes
#
#  index_video_uploads_on_videoable_type_and_videoable_id  (videoable_type,videoable_id)
#

#
# == VideoUpload Model
#
class VideoUpload < ActiveRecord::Base
  include Attachable

  belongs_to :videoable, polymorphic: true

  has_one :video_subtitle, as: :subtitleable, dependent: :destroy
  accepts_nested_attributes_for :video_subtitle, reject_if: :all_blank, allow_destroy: true

  handle_attachment :video_file,
                    styles: {
                      mp4video: {
                        geometry: '1280x720',
                        format: 'mp4',
                      },
                      oggvideo: {
                        geometry: '1280x720',
                        format: 'ogg'
                      },
                      webmvideo: {
                        geometry: '1280x720',
                        format: 'webm',
                      },
                      preview: {
                        geometry: '380x240#',
                        format: 'jpg',
                        time: 2
                      }
                    },
                    processors: [:transcoder],
                    max_size: 300.megabytes

  validates_attachment_content_type :video_file, content_type: %r{\Avideo\/.*\Z}
  process_in_background :video_file, processing_image_url: '/default/medium-missing.png'

  delegate :online, to: :video_subtitle, prefix: true, allow_nil: true

  scope :online, -> { where(online: true) }
end
