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

  handle_attachment :video,
                    styles: {
                      mp4video: {
                        geometry: '520x390',
                        format: 'mp4',
                      },
                      oggvideo: {
                        geometry: '520x390',
                        format: 'ogg'
                      },
                      webmvideo: {
                        geometry: '520x390',
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

  validates_attachment_content_type :video, content_type: %r{\Avideo\/.*\Z}

  scope :online, -> { where(online: true) }
end
