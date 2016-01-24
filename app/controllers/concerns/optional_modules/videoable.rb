#
# == VideoableConcern
#
module Videoable
  extend ActiveSupport::Concern

  included do
    before_action :set_video_settings, if: proc { @video_module.enabled? }
    after_action :flash_notice, only: [:create, :update], unless: proc { try(:flash_notice).blank? }

    private

    def set_video_settings
      @video_settings = VideoSetting.first
    end

    def flash_notice
      flash[:notice] = resource.flash_notice
    end
  end
end
