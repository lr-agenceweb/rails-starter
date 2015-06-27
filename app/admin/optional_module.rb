ActiveAdmin.register OptionalModule do
  menu parent: 'configuration'

  permit_params :id,
                :name,
                :enabled

  decorate_with OptionalModuleDecorator
  config.clear_sidebar_sections!

  index do
    selectable_column
    column :name
    column :status

    actions
  end

  show do
    attributes_table do
      row :name
      row :status
    end
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys

    f.inputs 'Général' do
      f.input :name,
              collection: OptionalModule.list,
              include_blank: false,
              input_html: { class: 'chosen-select' }
      f.input :enabled
    end

    f.actions
  end
end
