#
# == VideoSettingDecorator
#
class VideoSettingDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  delegate_all

  def video_platform_d
    color = model.video_platform? ? 'green' : 'red'
    status_tag_deco I18n.t("enabled.#{model.video_platform}"), color
  end

  def video_upload_d
    color = model.video_upload? ? 'green' : 'red'
    status_tag_deco I18n.t("enabled.#{model.video_upload}"), color
  end

  def video_background_d
    color = model.video_background? ? 'green' : 'red'
    status_tag_deco I18n.t("enabled.#{model.video_background}"), color
  end
end
