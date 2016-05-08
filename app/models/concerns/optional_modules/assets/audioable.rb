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
        attr_accessor :flash_notice

        has_many :audios, as: :audioable, dependent: :destroy
        accepts_nested_attributes_for :audios, reject_if: proc { |attribute| attribute['audio'].blank? }, allow_destroy: true

        has_one :audio, as: :audioable, dependent: :destroy
        accepts_nested_attributes_for :audio, reject_if: proc { |attribute| attribute['audio'].blank? }, allow_destroy: true

        delegate :online, to: :audios, prefix: true, allow_nil: true

        def flash_upload_in_progress(*)
          self.flash_notice = I18n.t('audio.flash.upload_in_progress')
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
