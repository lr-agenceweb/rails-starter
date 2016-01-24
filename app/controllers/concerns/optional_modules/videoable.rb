#
# == VideoableConcern
#
module Videoable
  extend ActiveSupport::Concern

  included do
    before_action :set_video_settings, if: proc { @video_module.enabled? }
    after_action :set_flash_notice, only: [:create, :update], if: proc { defined?(flash_notice) && !flash_notice.blank? }

    private

    def set_video_settings
      @video_settings = VideoSetting.first
    end

    def set_flash_notice
      flash[:notice] = flash_notice
    end
  end
end
