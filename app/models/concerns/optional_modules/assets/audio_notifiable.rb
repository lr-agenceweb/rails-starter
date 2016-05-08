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
    # == AudioNotifiable Concerns
    #
    module AudioNotifiable
      extend ActiveSupport::Concern

      included do
        attr_accessor :audio_flash_notice
        after_commit :audio_flash_upload_in_progress

        private

        def audio_flash_upload_in_progress(*)
          # Audio object
          if defined?(resource) && resource.is_a?(Audio)
            self.audio_flash_notice = I18n.t('audio.flash.upload_in_progress') if !resource.nil? && resource.audio_processing? && !resource.destroyed?

          # self Audio object
          elsif is_a?(Audio) && !nil? && audio_processing? && !destroyed?
            self.audio_flash_notice = I18n.t('audio.flash.upload_in_progress')
          end
        end
      end
    end
  end
end
