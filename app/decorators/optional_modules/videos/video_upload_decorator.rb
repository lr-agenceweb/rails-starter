# frozen_string_literal: true

#
# VideoUploadDecorator
# ======================
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
  # File
  # ======
  def file_name_without_extension
    super 'video_file'
  end

  #
  # Status tag
  # ============
  def subtitles
    bool = subtitles? ? true : false
    color = bool ? 'green' : 'red'
    status_tag_deco I18n.t("subtitles.#{bool}"), color
  end

  #
  # ActiveAdmin
  # =============
  def hint_for_paperclip
    html = []
    html << t('formtastic.hints.video_upload.video_file')
    html << safe_join([raw(t('video_upload.flash.upload_in_progress'))]) if !new_record? && video_file_processing?
    html << retina_image_tag(model, :video_file, :preview) unless new_record?
    safe_join [html], tag(:br)
  end
end
