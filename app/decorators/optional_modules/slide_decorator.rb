#
# == SlideDecorator
#
class SlideDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  delegate_all

  def caption
    content_tag(:div, model.title, class: 'orbit-caption') if slide.title?
  end
end
