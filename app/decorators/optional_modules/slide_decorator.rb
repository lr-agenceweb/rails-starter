#
# == SlideDecorator
#
class SlideDecorator < PictureDecorator
  include Draper::LazyHelpers
  delegate_all

  def caption
    raw(h.content_tag(:div, '', class: 'caption') do
      concat(h.content_tag(:h3, model.title, class: 'caption-title')) if slide.title?
      concat(h.content_tag(:div, model.description, class: 'caption-content')) if slide.description?
    end.html_safe) if caption?
  end

  def self_image_has_one_by_size(size = :slide)
    retina_image_tag self, :image, size, data: interchange_self
  end

  def image_deco
    retina_image_tag self, :image, :small
  end

  def title_deco
    model.title if title?
  end

  def description_deco
    model.description if description?
  end

  def slider_page_name
    model.attachable.category.title
  end

  #
  # ActiveAdmin
  #
  def title_aa_show
    "#{I18n.t('activerecord.models.slide.one')} liée au slider de la page #{slider_page_name}"
  end

  def title_aa_edit
    "#{t('active_admin.edit')} #{I18n.t('activerecord.models.slide.one')} liée au slider de la page #{slider_page_name}"
  end

  private

  def caption?
    slide.title? || slide.description?
  end

  def interchange_self
    { interchange: "[#{model.self_image_url_by_size(:slide)}, (default)], [#{model.self_image_url_by_size(:small)}, (small)], [#{model.self_image_url_by_size(:medium)}, (medium)], [#{model.self_image_url_by_size(:slide)}, (large)]" }
  end
end
