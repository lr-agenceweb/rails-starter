#
# == BackgroundDecorator
#
class BackgroundDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  delegate_all

  def image_deco
    retina_image_tag model, :image, :small
  end

  def category_name
    source_background.title
  end

  #
  # ActiveAdmin
  #
  def title_aa_show
    "#{I18n.t('activerecord.models.background.one')} lié à la page #{category_name}"
  end

  private

  # Category where the Background comes from
  #
  #
  def source_background
    model.attachable_type.constantize.find(model.attachable_id)
  end
end
