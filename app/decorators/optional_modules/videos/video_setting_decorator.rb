#
# == VideoSettingDecorator
#
class VideoSettingDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  delegate_all

  def video_platform
    color = model.video_platform? ? 'green' : 'red'
    status_tag_deco I18n.t("enabled.#{model.video_platform}"), color
  end

  def video_upload
    color = model.video_upload? ? 'green' : 'red'
    status_tag_deco I18n.t("enabled.#{model.video_upload}"), color
  end

  def video_background
    color = model.video_background? ? 'green' : 'red'
    status_tag_deco I18n.t("enabled.#{model.video_background}"), color
  end

  def turn_off_the_light
    color = model.turn_off_the_light? ? 'green' : 'red'
    status_tag_deco I18n.t("enabled.#{model.turn_off_the_light}"), color
  end
end
