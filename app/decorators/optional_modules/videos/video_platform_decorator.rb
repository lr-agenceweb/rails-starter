#
# == VideoPlatformDecorator
#
class VideoPlatformDecorator < VideoDecorator
  include Draper::LazyHelpers
  delegate_all

  def preview
    video_info = VideoInfo.new(model.url)
    image_tag video_info.thumbnail_medium if video_platform_available?(video_info)
  end

  def video_link
    link_to model.url, model.url, target: :blank
  end

  private

  def video_platform_available?(video_info)
    !video_info.nil? && video_info.available?
  end
end
