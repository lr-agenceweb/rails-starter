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
    model.attachable.menu_title
  end

  def handle_background_tag(content = nil, klass = '')
    content_tag(:div, content, class: "background #{klass}", style: "background-image: url(#{model.self_image_url_by_size(:background)});", data: interchange_background)
  end

  #
  # ActiveAdmin
  #
  def title_aa_show
    "#{I18n.t('activerecord.models.background.one')} lié à la page \"#{category_name}\""
  end

  def title_aa_edit
    "#{t('active_admin.edit')} #{I18n.t('activerecord.models.background.one')} page \"#{category_name}\""
  end

  private

  def interchange_background
    { interchange: "[#{model.self_image_url_by_size(:background)}, (default)], [#{model.self_image_url_by_size(:small)}, (small)], [#{model.self_image_url_by_size(:medium)}, (medium)], [#{model.self_image_url_by_size(:background)}, (large)]" }
  end
end
