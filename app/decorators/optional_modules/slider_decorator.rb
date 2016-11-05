# frozen_string_literal: true

#
# == SliderDecorator
#
class SliderDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  delegate_all

  #
  # == ActiveAdmin
  #
  def title_aa_show
    "#{I18n.t('activerecord.models.slider.one')} page #{page}"
  end

  def page
    I18n.t("activerecord.models.#{model.page_name.downcase}.one")
  end

  def time_to_show
    "#{model.time_to_show / 1000} #{I18n.t('time.label.seconds')}"
  end
end
