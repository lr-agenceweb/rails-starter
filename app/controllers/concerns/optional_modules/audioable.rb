# frozen_string_literal: true

#
# == OptionalModules namespace
#
module OptionalModules
  #
  # == AudioableConcern
  #
  module Audioable
    extend ActiveSupport::Concern

    included do
      after_action :set_audio_flash_notice, only: [:create, :update]

      private

      def set_audio_flash_notice
        if audio_object?
          (flash[:notice] ||= []) << resource.audio_flash_notice
        elsif audioable_object?
          (flash[:notice] ||= []) << resource.audio.audio_flash_notice
        end
      end

      def audio_object?
        # Audio object
        defined?(resource) &&
          resource.is_a?(Audio) &&
          defined?(resource.audio_flash_notice) &&
          !resource.audio_flash_notice.blank?
      end

      def audioable_object?
        # Audioable relation object
        defined?(resource.audio.audio_flash_notice) &&
          !resource.audio.audio_flash_notice.blank?
      end
    end
  end
end
