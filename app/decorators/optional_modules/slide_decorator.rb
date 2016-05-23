# frozen_string_literal: true

#
# == SlideDecorator
#
class SlideDecorator < PictureDecorator
  include Draper::LazyHelpers
  delegate_all

  #
  # == Slide
  #
  def description_deco
    raw(model.description) if description?
  end

  def slider_page_name
    model.attachable.category.menu_title
  end

  def self_image_has_one_by_size(size = :slide)
    retina_image_tag self, :image, size, data: interchange_self
  end

  #
  # == ActiveAdmin
  #
  def title_aa_show
    "#{I18n.t('activerecord.models.slide.one')} liée au slider de la page #{slider_page_name}"
  end

  def title_aa_edit
    "#{t('active_admin.edit')} #{I18n.t('activerecord.models.slide.one')} liée au slider de la page #{slider_page_name}"
  end

  def caption?
    slide.title? || slide.description?
  end
end
