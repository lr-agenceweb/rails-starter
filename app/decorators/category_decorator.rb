#
# == CategoryDecorator
#
class CategoryDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  delegate_all

  def title_d
    model.menu_title
  end

  def background_deco
    if background?
      retina_image_tag model.background, :image, :small
    else
      'Pas de Background associé'
    end
  end

  def div_color
    if model.color.blank?
      content_tag(:span, 'Pas de couleur')
    else
      content_tag(:div, '', style: "background-color: #{model.color}; width: 35px; height: 20px;")
    end
  end

  #
  # == ActiveAdmin
  #
  def title_aa_show
    aa_page_name.titleize
  end

  def title_aa_edit
    "#{t('active_admin.edit')} #{aa_page_name}"
  end

  #
  # == Optional Modules
  #
  def module
    message = 'Module activé'
    color = 'blue'
    if !model.optional && model.optional_module_id.nil?
      message = 'Module de base'
      color = ''
    else
      if model.optional && !model.optional_module_enabled
        message = 'Module non activé'
        color = 'red'
      end
    end

    arbre do
      status_tag message, color
    end
  end

  #
  # == Optional Modules
  #
  def video_preview
    h.retina_image_tag model.video_upload, :video_file, :preview
  end

  #
  # == Videos
  #
  def video?
    model.try(:video_upload_online) && model.try(:video_upload).try(:video_file).exists?
  end

  private

  def aa_page_name
    "#{I18n.t('activerecord.models.category.one').downcase} \"#{model.decorate.menu_title}\""
  end
end
