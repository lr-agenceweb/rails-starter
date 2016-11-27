# frozen_string_literal: true

#
# VideoPlatformDecorator
# ========================
class VideoPlatformDecorator < VideoDecorator
  include Draper::LazyHelpers
  delegate_all

  def video_link
    link_to model.url, model.url, target: :_blank
  end

  #
  # Columns
  # =========
  def title_d
    video_info = VideoInfo.new(model.url)
    return video_info.title if model.native_informations? && video_platform_available?(video_info)
    return model.title if title? && !model.native_informations?
  end

  def description_d
    video_info = VideoInfo.new(model.url)
    desc = video_info.description if model.native_informations? && video_platform_available?(video_info)
    desc = model.description if description? && !model.native_informations?
    safe_join [raw(desc)]
  end

  def preview
    video_info = VideoInfo.new(model.url)
    image_tag video_info.thumbnail_medium if video_platform_available?(video_info)
  end

  #
  # ActiveAdmin
  # =============
  def hint_for_paperclip(video_info: nil)
    html = []
    html << safe_join([raw(t('formtastic.hints.video_platform.url'))])
    html << image_tag(video_info.thumbnail_medium) if !video_info.nil? && video_info.available?

    safe_join [html], tag(:br)
  end

  private

  def video_platform_available?(video_info)
    !video_info.nil? && video_info.available?
  end
end
