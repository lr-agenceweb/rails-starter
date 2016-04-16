# frozen_string_literal: true
#
# == ReferencementDecorator
#
class ReferencementDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  delegate_all

  def letters_length
    length = description? ? model.description.length : 0
    150 - length
  end
end
