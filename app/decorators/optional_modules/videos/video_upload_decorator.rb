# frozen_string_literal: true

#
# == VideoUploadDecorator
#
class VideoUploadDecorator < VideoDecorator
  include Draper::LazyHelpers
  delegate_all

  def title_microdatas
    title? ? title : model.video_file_file_name.humanize
  end

  def description_microdatas
    description? ? description : title_microdatas
  end

  def preview
    h.retina_image_tag model, :video_file, :preview
  end

  def page?
    videoable_type == 'Page'
  end

  #
  # == File
  #
  def file_name_without_extension
    super 'video_file'
  end

  #
  # == Status tag
  #
  def subtitles
    bool = subtitles? ? true : false
    color = bool ? 'green' : 'red'
    status_tag_deco I18n.t("subtitles.#{bool}"), color
  end

  private

  def subtitles?
    model.video_subtitle_online && (model.video_subtitle.subtitle_fr.exists? || model.video_subtitle.subtitle_en.exists?)
  end
end
