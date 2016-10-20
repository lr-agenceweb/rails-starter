# frozen_string_literal: true

#
# == ReferencementDecorator
#
class ReferencementDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  delegate_all
end
