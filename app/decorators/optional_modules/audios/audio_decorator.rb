# frozen_string_literal: true

#
# AudioDecorator
# ================
class AudioDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  delegate_all

  #
  # File
  # ======
  def file_name_without_extension
    super 'audio'
  end

  def hint_for_paperclip
    html = []
    html << t('formtastic.hints.audio.audio_file')

    if model.audio?
      human_file_name = content_tag(:strong, model.audio_file_name.humanize)
      html << safe_join([raw(t('formtastic.hints.audio.actual_file', file: human_file_name))])
    end

    safe_join [html], tag(:br)
  end
end
