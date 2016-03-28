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

  def title_d
    video_info = VideoInfo.new(model.url)
    return video_info.title if model.native_informations? && video_platform_available?(video_info)
    return model.title if title? && !model.native_informations?
  end

  def description_d
    video_info = VideoInfo.new(model.url)
    desc = video_info.description if model.native_informations? && video_platform_available?(video_info)
    desc = model.description if description? && !model.native_informations?
    raw(desc)
  end

  private

  def video_platform_available?(video_info)
    !video_info.nil? && video_info.available?
  end
end
