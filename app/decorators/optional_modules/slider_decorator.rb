#
# == SliderDecorator
#
class SliderDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  include Imageable
  delegate_all

  def page
    I18n.t("activerecord.models.#{model.category_name.downcase}.one")
  end

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

  def slider_options
    "animation: #{model.animate}; timer_speed: #{model.time_to_show}; pause_on_hover: #{model.hover_pause}; resume_on_mouseout: true; navigation_arrows: #{model.navigation}; slide_number: false; bullet: #{model.bullet}; circular: #{model.loop}; timer: #{model.autoplay}; swipe: true"
  end

  def title_aa_show
    "#{I18n.t('activerecord.models.slider.one')} page #{resource.page}"
  end

  def loop_hover_has_many_pictures(size = :slide)
    h.content_tag(:ul, '', class: 'slides', data: { orbit: '', options: slider_options }) do
      model.slides_online.each do |slide|
        concat(h.content_tag(:li) do
          concat(slide.decorate.self_image_has_one_by_size(size))
          concat(slide.decorate.caption)
        end)
      end
    end if model.slides?
  end

  private

  def status_slider(property)
    v = model[property]
    color = v ? 'green' : 'red'
    status_tag_deco I18n.t("enabled.#{v}"), color
  end
end
