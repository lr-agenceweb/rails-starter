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
        # Audio object
        if defined?(resource) && resource.is_a?(Audio) && defined?(resource.audio_flash_notice) && !resource.audio_flash_notice.blank?
          (flash[:notice] ||= []) << resource.audio_flash_notice

        # Audioable relation object
        elsif defined?(resource.audio.audio_flash_notice) && !resource.audio.audio_flash_notice.blank?
          (flash[:notice] ||= []) << resource.audio.audio_flash_notice
        end
      end
    end
  end
end
