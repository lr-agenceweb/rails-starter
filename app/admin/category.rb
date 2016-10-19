# frozen_string_literal: true
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
      columns do
        column do
          attributes_table do
            row :cover_preview
            row :div_color
            row :slider if slider_module.enabled?
            row :module if current_user.super_administrator?
            row :video_preview if show_video_background?(video_settings, video_module) && resource.video?
          end
        end

        column do
          render 'heading', heading: resource.heading

          render 'admin/shared/referencement/show', referencement: resource.referencement
        end
      end
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)

    columns do
      column do
        f.inputs t('formtastic.titles.category_details') do
          f.input :menu_id,
                  as: :select,
                  collection: nested_dropdown(Menu.self_or_available(f.object)),
                  include_blank: false,
                  input_html: {
                    disabled: current_user.super_administrator? ? false : :disbaled
                  }

          f.input :color,
                  as: :color_picker,
                  palette: [
                    SharedColoredVariables::PRIMARY_COLOR,
                    SharedColoredVariables::SECONDARY_COLOR,
                    SharedColoredVariables::TERCERY_COLOR,
                    '#FFFFFF',
                    '#000000'
                  ],
                  hint: true
        end

        render 'admin/shared/referencement/form', f: f, klass: params[:section] == 'referencement' ? 'highlight-referencement' : ''
      end

      column do
        render 'admin/shared/heading/form', f: f, klass: params[:section] == 'heading' ? 'highlight-heading' : ''
        render 'admin/shared/backgrounds/form', f: f if background_module.enabled?
      end
    end

    columns do
      column do
        render 'admin/shared/video_uploads/one', f: f if video_module.enabled? && video_settings.video_upload? && video_settings.video_background?
      end
    end

    render 'admin/shared/optional_modules/form', f: f if current_user.super_administrator?

    f.actions
  end

  #
  # == Controller
  #
  controller do
    include AssetsHelper
    include Core::MenuHelper
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
