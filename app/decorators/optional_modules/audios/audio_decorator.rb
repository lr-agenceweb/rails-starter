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
end
