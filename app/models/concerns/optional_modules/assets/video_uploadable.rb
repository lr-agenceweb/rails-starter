# frozen_string_literal: true

#
# == Module OptionalModules
#
module OptionalModules
  #
  # == Module Assets
  #
  module Assets
    #
    # == VideoUploadable Concerns
    #
    module VideoUploadable
      extend ActiveSupport::Concern

      included do
        include OptionalModules::Assets::FlashNotifiable

        has_many :video_uploads, -> { order(:position) }, as: :videoable, dependent: :destroy, before_add: :video_upload_flash_upload_in_progress
        accepts_nested_attributes_for :video_uploads, reject_if: :reject_video_upload?, allow_destroy: true

        has_one :video_upload, as: :videoable, dependent: :destroy
        accepts_nested_attributes_for :video_upload, reject_if: :reject_video_upload?, allow_destroy: true

        delegate :online, to: :video_uploads, prefix: true, allow_nil: true
        delegate :online, to: :video_upload, prefix: true, allow_nil: true

        def reject_video_upload?(attributes)
          (new_record? && attributes['video_file'].blank?) ||
            (!attributes['id'].blank? && attributes['video_file'].blank?)
        end

        def video_uploads?
          video_uploads.online.any? && !video_uploads.first.video_file_processing?
        end
      end
    end
  end
end
