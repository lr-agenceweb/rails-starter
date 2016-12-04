# frozen_string_literal: true

#
# VideoSubtitleDecorator
# ========================
class VideoSubtitleDecorator < VideoDecorator
  include Draper::LazyHelpers
  delegate_all

  #
  # ActiveAdmin
  # =============
  def hint_for_paperclip(attribute: :subtitle_fr)
    html = []
    html << t("formtastic.hints.video_subtitle.#{attribute}")
    html << "#{model.send("#{attribute}_file_name")} le #{I18n.l(model.created_at, format: :short)}" if send("#{attribute}?")

    safe_join [html], tag(:br)
  end
end
