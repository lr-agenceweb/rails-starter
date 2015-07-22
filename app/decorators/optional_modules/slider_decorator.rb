#
# == SliderDecorator
#
class SliderDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  delegate_all

  def page
    model.category_name
  end

  def autoplay
    status_slider 'autoplay'
  end

  def hover_pause
    status_slider 'hover_pause'
  end

  def loop
    status_slider 'loop'
  end

  def navigation
    status_slider 'navigation'
  end

  def bullet
    status_slider 'bullet'
  end

  def slider_options
    "animation: #{model.animate}; timer_speed: #{model.timeout}; pause_on_hover: #{model.hover_pause}; resume_on_mouseout: true; navigation_arrows: #{model.navigation}; slide_number: false; bullet: #{model.bullet}; circular: #{model.loop}; timer: #{model.autoplay}; swipe: true"
  end

  private

  def status_slider(property)
    v = model[property]
    color = v ? 'green' : 'red'
    status_tag_deco I18n.t("enabled.#{v}"), color
  end
end
