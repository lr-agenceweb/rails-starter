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
        after_commit :video_flash_upload_in_progress, if: :self_videouploadable? || :resource_videouploadable?

        private

        def video_flash_upload_in_progress(*)
          self.video_flash_notice = I18n.t('video_upload.flash.upload_in_progress')
        end

        def self_videouploadable?
          is_a?(VideoUpload) &&
            !nil? &&
            !destroyed? &&
            video_file_processing?
        end

        def resource_videouploadable?
          defined?(resource) &&
            resource.is_a?(VideoUpload) &&
            !resource.nil? &&
            !resource.destroyed? &&
            resource.video_file_processing?
        end
      end
    end
  end
end
