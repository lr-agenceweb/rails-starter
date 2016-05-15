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
        after_commit :audio_flash_upload_in_progress, if: :self_audioable? || :resource_audioable?

        private

        def audio_flash_upload_in_progress(*)
          self.audio_flash_notice = I18n.t('audio.flash.upload_in_progress')
        end

        def self_audioable?
          is_a?(Audio) &&
            !nil? &&
            !destroyed? &&
            audio_processing?
        end

        def resource_audioable?
          defined?(resource) &&
            resource.is_a?(Audio) &&
            !resource.nil? &&
            !resource.destroyed? &&
            resource.audio_processing?
        end
      end
    end
  end
end
