# frozen_string_literal: true

#
# == OptionalModules namespace
#
module OptionalModules
  #
  # == VideoableConcern
  #
  module Videoable
    extend ActiveSupport::Concern

    included do
      before_action :set_video_settings, if: proc { @video_module.enabled? }
      after_action :set_video_upload_flash_notice, only: [:create, :update], if: :defined_video_upload_flash_notice?

      private

      def set_video_settings
        @video_settings = VideoSetting.first
        gon.push(
          turn_off_the_light: @video_settings.turn_off_the_light
        )
      end

      def set_video_upload_flash_notice
        # has_many relation
        if video_upload_flash_notice?(resource)
          (flash[:notice] ||= []) << resource.video_upload_flash_notice

        # has_one relation
        elsif !resource.is_a?(VideoUpload) && video_upload_flash_notice?(resource.try(:video_upload))
          (flash[:notice] ||= []) << resource.video_upload.video_upload_flash_notice
        end
      end

      def video_upload_flash_notice?(r)
        defined?(r.video_upload_flash_notice) &&
          !r.video_upload_flash_notice.blank?
      end

      def defined_video_upload_flash_notice?
        defined?(resource.video_upload_flash_notice) ||
          defined?(resource.video_upload.video_upload_flash_notice)
      end
    end
  end
end
