ActiveAdmin.register Category do
  menu parent: 'Outils'

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
                ]

  config.clear_sidebar_sections!
  actions :all, except: [:new, :destroy]

  index do
    column :title do |resource|
      raw "<strong>#{resource.title}</strong>"
    end

    column :show_in_menu
    column :show_in_footer

    column :referencement do |resource|
      render 'admin/shared/referencement/show', resource: resource
    end

    translation_status
    actions
  end

  show do
    h3 resource.title
    attributes_table do
      row :show_in_menu do
        status_tag("#{resource.show_in_menu}", (resource.show_in_menu? ? :ok : :warn))
      end
      row :show_in_footer do
        status_tag("#{resource.show_in_footer}", (resource.show_in_footer? ? :ok : :warn))
      end

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

    render 'admin/shared/referencement/form', f: f

    f.actions
  end
end
