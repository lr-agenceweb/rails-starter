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
    I18n.t("activerecord.models.#{model.category_name.downcase}.one")
  end

  #
  # == Status tag
  #
  def autoplay_deco
    status_slider 'autoplay'
  end

  def hover_pause_deco
    status_slider 'hover_pause'
  end

  def loop_deco
    status_slider 'loop'
  end

  def navigation_deco
    status_slider 'navigation'
  end

  def bullet_deco
    status_slider 'bullet'
  end

  def time_to_show_deco
    "#{model.time_to_show / 1000} #{I18n.t('time.label.seconds')}"
  end

  private

  def status_slider(property)
    v = model[property]
    color = v ? 'green' : 'red'
    status_tag_deco I18n.t("enabled.#{v}"), color
  end
end
