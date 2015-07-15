ActiveAdmin.register Category do
  menu parent: 'configuration'
  includes :background, :translations, :referencement

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
  config.sort_order = 'position_asc'
  config.paginate   = false

  sortable # creates the controller action which handles the sorting

  index do
    sortable_handle_column
    column :background
    column :title
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
    f.semantic_errors *f.object.errors.keys

    f.inputs 'Général' do
      f.input :name,
              collection: Category.models_name,
              include_blank: false,
              input_html: { class: 'chosen-select' }
      f.input :color,
              input_html: { class: 'colorpicker' }
      f.input :show_in_menu
      f.input :show_in_footer
    end

    f.inputs 'Catégorie' do
      f.translated_inputs 'Translated fields', switch_locale: true do |t|
        t.input :title, hint: 'Titre du menu'
      end
    end

    render 'admin/shared/backgrounds/form', f: f
    render 'admin/shared/referencement/form', f: f
    render 'admin/shared/optional_modules/form', f: f if current_user_and_administrator?

    f.actions
  end
end
