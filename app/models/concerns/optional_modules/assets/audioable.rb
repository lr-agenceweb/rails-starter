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
    # == Audioable Concerns
    #
    module Audioable
      extend ActiveSupport::Concern

      included do
        include OptionalModules::Assets::FlashNotifiable

        has_many :audios, as: :audioable, dependent: :destroy, before_add: :audio_flash_upload_in_progress
        accepts_nested_attributes_for :audios, reject_if: :reject_audio?, allow_destroy: true

        has_one :audio, as: :audioable, dependent: :destroy
        accepts_nested_attributes_for :audio, reject_if: :reject_audio?, allow_destroy: true

        delegate :online, to: :audios, prefix: true, allow_nil: true

        def reject_audio?(attributes)
          (new_record? && attributes['audio'].blank?) ||
            (attributes['id'].blank? && attributes['audio'].blank?)
        end

        def audio?
          audio.present? && audio.audio.exists? && audio.online?
        end

        def audios?
          audios.online.first.present? && audios.online.first.audio.exists?
        end
      end
    end
  end
end
