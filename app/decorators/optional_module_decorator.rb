# frozen_string_literal: true

#
# == OptionalModuleDecorator
#
class OptionalModuleDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  delegate_all

  #
  # Content
  #
  def name
    content_tag :strong, translated_module_name
  end

  #
  # == ActiveAdmin
  #
  def title_aa_show
    translated_module_name
  end

  private

  def translated_module_name
    t("optional_module.name.#{model.name.underscore.downcase}")
  end
end
