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
      include ApplicationHelper

      included do
        attr_accessor :flash_notice
        after_save :flash_upload_in_progress

        has_one :video_upload, as: :videoable, dependent: :destroy
        accepts_nested_attributes_for :video_upload, reject_if: proc { |attributes| attributes['video_file'].blank? }, allow_destroy: true

        delegate :online, to: :video_upload, prefix: true, allow_nil: true

        def flash_upload_in_progress
          self.flash_notice = I18n.t('video_upload.flash.upload_in_progress') if !video_upload.nil? && video_upload.video_file_processing? && !video_upload.destroyed?
        end
      end
    end
  end
end
