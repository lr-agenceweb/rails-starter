# frozen_string_literal: true

#
# == StringBox Decorator
#
class StringBoxDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  delegate_all

  def content
    safe_join [raw(model.content)] if content?
  end

  #
  # ActiveAdmin
  #
  def title_aa_show
    title? ? model.title : model.key.titleize
  end
end
