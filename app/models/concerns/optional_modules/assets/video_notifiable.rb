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
    # == VideoNotifiable Concerns
    #
    module VideoNotifiable
      extend ActiveSupport::Concern

      included do
        attr_accessor :video_flash_notice
        after_commit :video_flash_upload_in_progress

        private

        def video_flash_upload_in_progress(*)
          return unless self_videouploadable? || resource_videouploadable?
          self.video_flash_notice = I18n.t('video_upload.flash.upload_in_progress')
        end

        def self_videouploadable?
          is_a?(VideoUpload) &&
            !nil? &&
            !destroyed? &&
            video_file_processing?
        end

        def resource_videouploadable?
          return false if is_a?(VideoUpload)
          video_uploads.each do |video_upload|
            return true if !video_upload.nil? &&
                           !video_upload.destroyed? &&
                           video_upload.video_file_processing?
          end
          false
        end
      end
    end
  end
end
