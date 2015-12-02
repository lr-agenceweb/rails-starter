#
# == VideoableConcern
#
module Videoable
  extend ActiveSupport::Concern

  included do
    before_action :set_video_settings, if: proc { @video_module.enabled? }

    private

    def set_video_settings
      @video_settings = VideoSetting.first
    end
  end
end
