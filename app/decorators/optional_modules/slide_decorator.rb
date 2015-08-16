#
# == SlideDecorator
#
class SlideDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  delegate_all

  def caption
    h.content_tag(:div, '', class: 'caption') do
      concat(h.content_tag(:h3, model.title, class: 'caption-title')) if slide.title?
      concat(h.content_tag(:div, model.description, class: 'caption-content')) if slide.description?
    end if caption?
  end

  def self_image_has_one_by_size(size = :slide)
    retina_image_tag self, :image, size, data: interchange_self
  end

  private

  def caption?
    slide.title? || slide.description?
  end

  def interchange_self
    { interchange: "[#{model.self_image_url_by_size(:slide)}, (default)], [#{model.self_image_url_by_size(:small)}, (small)], [#{model.self_image_url_by_size(:medium)}, (medium)], [#{model.self_image_url_by_size(:slide)}, (large)]" }
  end
end
