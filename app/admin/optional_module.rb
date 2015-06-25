ActiveAdmin.register OptionalModule do
  menu parent: I18n.t('admin_menu.configuration')

  permit_params :id,
                :name,
                :enabled

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
