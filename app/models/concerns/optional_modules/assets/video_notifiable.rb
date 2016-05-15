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
        after_commit :video_flash_upload_in_progress, if: :upload_in_progress?

        private

        def video_flash_upload_in_progress(*)
          self.video_flash_notice = I18n.t('video_upload.flash.upload_in_progress')
        end

        def upload_in_progress?
          # VideoUpload object
          (defined?(resource) && resource.is_a?(VideoUpload) && !resource.nil? && resource.video_file_processing? && !resource.destroyed?) ||
            # self VideoUpload object
            (is_a?(VideoUpload) && !nil? && video_file_processing? && !destroyed?)
        end
      end
    end
  end
end
