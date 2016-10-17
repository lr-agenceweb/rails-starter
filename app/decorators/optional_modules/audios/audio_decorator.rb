# frozen_string_literal: true

#
# == AudioDecorator
#
class AudioDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  delegate_all

  #
  # == File
  #
  def file_name_without_extension
    super 'audio'
  end

  def hint_for_file
    html = t('formtastic.hints.audio.audio_file')
    html += model.audio? ? '<br />' + t('formtastic.hints.audio.actual_file', file: "<strong>#{model.audio_file_name.humanize}</strong>") : ''
    html
  end
end
