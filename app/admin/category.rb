# frozen_string_literal: true
include Core::MenuHelper

ActiveAdmin.register Category do
  menu parent: I18n.t('admin_menu.config')
  includes :background, :slider, :optional_module, :menu, menu: [:translations]

  permit_params do
    params = [:id, :name, :color]
    params.push :optional, :menu_id, :optional_module_id if current_user.super_administrator?
    params.push(*referencement_attributes)
    params.push(*heading_attributes)
    params.push(*background_attributes) if @background_module.enabled?
    params.push(*video_upload_attributes) if show_video_background?(@video_settings, @video_module)
    params
  end

  decorate_with CategoryDecorator
  config.clear_sidebar_sections!
  config.sort_order = 'menus.position asc'

  batch_action :reset_cache, if: proc { can? :reset_cache, Category } do |ids|
    Category.find(ids).each(&:touch)
    redirect_to :back, notice: t('active_admin.batch_actions.reset_cache')
  end

  index do
    selectable_column
    column :cover_preview
    column :title_d
    column :div_color
    column :slider if slider_module.enabled?
    column :video_upload if show_video_background?(video_settings, video_module)
    column :module if current_user.super_administrator?

    actions
  end

  show title: :title_aa_show do
    arbre_cache(self, resource.cache_key) do
      render 'show', resource: resource
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)
    render 'form', f: f
  end

  #
  # == Controller
  #
  controller do
    include AssetsHelper
    include ActiveAdmin::ParamsHelper
    include Skippable
    include OptionalModules::Videoable

    def scoped_collection
      super.includes :video_upload, menu: [:translations]
    end

    def edit
      @page_title = resource.decorate.title_aa_edit
    end
  end
end
