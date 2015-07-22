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

  def custom_default_slider_options(gon)
    gon.push(
      animate: model.animate,
      autoplay: model.autoplay,
      timeout: model.timeout,
      hover_pause: model.hover_pause,
      loop: model.loop,
      navigation: model.navigation,
      bullet: model.bullet
    )
  end

  private

  def status_slider(property)
    v = model[property]
    color = v ? 'green' : 'red'
    status_tag_deco I18n.t("enabled.#{v}"), color
  end
end
