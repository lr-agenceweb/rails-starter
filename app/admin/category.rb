include MenuHelper
include AssetsHelper

ActiveAdmin.register Category do
  menu parent: I18n.t('admin_menu.config')
  includes :background, :slider, :optional_module, :menu, menu: [:translations]

  permit_params :id,
                :name,
                :color,
                :optional,
                :optional_module_id,
                :menu_id,
                referencement_attributes: [
                  :id,
                  translations_attributes: [
                    :id, :locale, :title, :description, :keywords
                  ]
                ],
                background_attributes: [
                  :id, :image, :_destroy
                ],
                heading_attributes: [
                  :id,
                  translations_attributes: [
                    :id, :locale, :content
                  ]
                ],
                video_upload_attributes: [
                  :id, :video_file, :online, :position, :delete_video_file,
                ]

  decorate_with CategoryDecorator
  config.clear_sidebar_sections!
  config.sort_order = 'menus.position asc'

  index do
    selectable_column
    column :background_deco if background_module.enabled?
    column :title_d
    column :div_color
    column :slider if slider_module.enabled?
    column :video_upload if video_background?(video_settings, video_module)
    column :module if current_user.super_administrator?

    actions
  end

  show title: :title_aa_show do
    columns do
      column do
        attributes_table do
          row :background_deco if background_module.enabled?
          row :div_color
          row :slider if slider_module.enabled?
          row :module if current_user.super_administrator?
          row :video_preview if video_background?(video_settings, video_module) && resource.video?
        end
      end

      column do
        render 'admin/shared/referencement/show', referencement: resource.referencement
      end
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)

    columns do
      column do
        f.inputs t('general') do
          f.input :menu_id,
                  as: :select,
                  collection: nested_dropdown(Menu.self_or_available(f.object)),
                  include_blank: false,
                  input_html: {
                    class: 'chosen-select',
                    disabled: current_user.super_administrator? ? false : :disbaled
                  },
                  hint: I18n.t('form.hint.category.menu_id')

          f.input :custom_background_color,
                  as: :boolean,
                  input_html: {
                    checked: f.object.color.blank? ? false : true
                  }

          f.input :color,
                  input_html: {
                    class: 'colorpicker',
                    value: f.object.color.blank? ? '' : f.object.color
                  }
        end

        render 'admin/shared/referencement/form', f: f
        render 'admin/shared/video_uploads/one', f: f if video_module.enabled? && video_settings.video_upload? && video_settings.video_background?
      end

      column do
        render 'admin/shared/heading/form', f: f
        render 'admin/shared/backgrounds/form', f: f if background_module.enabled?
      end
    end

    render 'admin/shared/optional_modules/form', f: f if current_user.super_administrator?

    f.actions
  end

  #
  # == Controller
  #
  controller do
    include Skippable
    include Videoable

    def scoped_collection
      super.includes menu: [:translations]
    end

    def edit
      @page_title = resource.decorate.title_aa_edit
    end

    def update
      unless current_user.super_administrator?
        params[:category].delete :optional_module_id
        params[:category].delete :optional
        params[:category].delete :menu_id
      end

      if params[:category][:custom_background_color] == '0'
        params[:category][:color] = nil
      end

      params[:category].delete :background_attributes unless @background_module.enabled?
      params[:category].delete :video_upload_attributes unless video_background?(@video_settings, @video_module)

      super
    end
  end
end
