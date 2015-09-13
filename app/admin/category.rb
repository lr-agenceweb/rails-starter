ActiveAdmin.register Category do
  menu parent: I18n.t('admin_menu.config')
  includes :background, :translations, :slider, :optional_module

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
                ]

  decorate_with CategoryDecorator
  config.clear_sidebar_sections!

  # Sortable
  sortable
  config.sort_order = 'position_asc'
  config.paginate   = false

  index do
    sortable_handle_column
    column :background_deco if background_module.enabled?
    column :title
    column :div_color
    column :slider if slider_module.enabled?
    column :in_menu
    column :in_footer
    column :module if current_user.super_administrator?

    translation_status
    actions
  end

  show title: :title_aa_show do
    columns do
      column do
        attributes_table do
          row :background_deco if background_module.enabled?
          row :div_color
          row :slider if slider_module.enabled?
          row :in_menu
          row :in_footer
          row :module if current_user.super_administrator?
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
                  collection: Menu.online,
                  include_blank: false,
                  input_html: { class: 'chosen-select' }

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
    def edit
      @page_title = resource.decorate.title_aa_edit
    end

    def update
      unless current_user.super_administrator?
        params[:category].delete :optional_module_id
        params[:category].delete :optional
      end

      if params[:category][:custom_background_color] == '0'
        params[:category][:color] = nil
      end

      params[:category].delete :background_attributes unless @background_module.enabled?

      super
    end
  end
end
