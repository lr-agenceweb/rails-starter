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
      after_action :set_flash_notice, only: [:create, :update], if: proc { defined?(resource.flash_notice) && !resource.flash_notice.blank? }

      private

      def set_video_settings
        @video_settings = VideoSetting.first
        gon.push(
          turn_off_the_light: @video_settings.turn_off_the_light
        )
      end

      def set_flash_notice
        flash[:notice] = resource.flash_notice
      end
    end
  end
end
