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
          return unless self_audioable? || resource_audioable?
          self.audio_flash_notice = I18n.t('audio.flash.upload_in_progress')
        end

        def self_audioable?
          is_a?(Audio) &&
            !nil? &&
            !destroyed? &&
            audio_processing?
        end

        def resource_audioable?
          return false if is_a?(Audio)
          audios.each do |audio|
            return true if !audio.nil? &&
                           !audio.destroyed? &&
                           audio.audio_processing?
          end
          false
        end
      end
    end
  end
end
