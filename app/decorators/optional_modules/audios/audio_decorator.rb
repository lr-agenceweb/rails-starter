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
    model.audio? ? "Fichier actuel: <strong>#{model.audio_file_name.humanize}</strong> <br />" : ''
  end
end
