ActiveAdmin.register Category do
  menu parent: 'configuration'

  permit_params :id,
                :name,
                :show_in_menu,
                :show_in_footer,
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
                  :id, :image
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

    column :referencement do |resource|
      render 'admin/shared/referencement/show', resource: resource
    end

    translation_status
    actions
  end

  show do
    h3 resource.title
    attributes_table do
      row :background
      row :in_menu
      row :in_footer

      render 'admin/shared/referencement/show', resource: resource
    end
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys

    f.inputs 'Général' do
      f.input :name,
              collection: Category.models_name,
              include_blank: false,
              input_html: { class: 'chosen-select' }
      f.input :show_in_menu
      f.input :show_in_footer
    end

    f.inputs 'Catégorie' do
      f.translated_inputs 'Translated fields', switch_locale: false do |t|
        t.input :title, hint: 'Titre du menu'
      end
    end

    render 'admin/shared/backgrounds/form', f: f
    render 'admin/shared/referencement/form', f: f

    f.actions
  end
end
