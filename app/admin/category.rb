ActiveAdmin.register Category do
  menu parent: 'configuration'
  includes :background, :translations, :slider, :optional_module

  permit_params :id,
                :name,
                :color,
                :show_in_menu,
                :show_in_footer,
                :optional,
                :optional_module_id,
                translations_attributes: [
                  :id, :locale, :title
                ],
                referencement_attributes: [
                  :id,
                  translations_attributes: [
                    :id, :locale, :title, :description, :keywords
                  ]
                ],
                background_attributes: [
                  :id, :image, :_destroy
                ]

  decorate_with CategoryDecorator
  config.clear_sidebar_sections!

  # Sortable
  sortable
  config.sort_order = 'position_asc'
  config.paginate   = false

  index do
    sortable_handle_column
    column :background
    column :title
    column :slider if slider_module.enabled?
    column :in_menu
    column :in_footer
    column :module if current_user.super_administrator?

    translation_status
    actions
  end

  show do
    columns do
      column do
        attributes_table do
          row :background
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
        f.inputs t('activerecord.models.category.one') do
          f.translated_inputs 'Translated fields', switch_locale: true do |t|
            t.input :title, hint: 'Titre du menu'
          end
        end

        f.inputs t('general') do
          columns do
            column do
              f.input :name,
                      collection: Category.models_name,
                      include_blank: false,
                      input_html: { class: 'chosen-select' }
            end

            column do
              f.input :show_in_menu
              f.input :show_in_footer
            end
          end
          f.input :color,
                  input_html: { class: 'colorpicker' }
        end
      end

      column do
        render 'admin/shared/referencement/form', f: f
      end
    end

    columns do
      column do
        render 'admin/shared/backgrounds/form', f: f
      end
    end

    render 'admin/shared/optional_modules/form', f: f if current_user.super_administrator?

    f.actions
  end

  #
  # == Controller
  #
  controller do
    def update
      unless current_user.super_administrator?
        params[:category].delete :optional_module_id
        params[:category].delete :optional
      end
      update! { admin_category_path(@category) }
    end
  end
end
