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
      after_action :set_audio_flash_notice, only: [:create, :update], if: proc { defined?(resource) }

      private

      def set_audio_flash_notice
        # has_many relation
        if audio_flash_notice?(resource)
          (flash[:notice] ||= []) << resource.audio_flash_notice

        # has_one relation
        elsif !resource.is_a?(Audio) && audio_flash_notice?(resource.audio)
          (flash[:notice] ||= []) << resource.audio.audio_flash_notice
        end
      end

      def audio_flash_notice?(r)
        defined?(r.audio_flash_notice) &&
          !r.audio_flash_notice.blank?
      end
    end
  end
end
