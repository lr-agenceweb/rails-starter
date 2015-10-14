#
# == VideoUploadDecorator
#
class VideoUploadDecorator < VideoDecorator
  include Draper::LazyHelpers
  delegate_all

  def preview
    h.retina_image_tag model, :video_file, :preview
  end

  def subtitles
    bool = subtitles?.nil? ? false : subtitles?
    color = bool ? 'green' : 'red'
    status_tag_deco I18n.t("subtitles.#{bool}"), color
  end

  def category?
    videoable_type == 'Category'
  end

  private

  def subtitles?
    model.video_subtitle_online && (model.video_subtitle.subtitle_fr.exists? || model.video_subtitle.subtitle_en.exists?)
  end
end
