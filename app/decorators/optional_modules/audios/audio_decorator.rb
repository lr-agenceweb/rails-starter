# frozen_string_literal: true

#
# == AudioDecorator
#
class AudioDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  delegate_all
end
