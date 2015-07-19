ActiveAdmin.register OptionalModule do
  menu parent: 'configuration'

  permit_params :id,
                :name,
                :description,
                :enabled

  decorate_with OptionalModuleDecorator
  config.clear_sidebar_sections!

  index do
    selectable_column
    column :name
    column :description
    column :status

    actions
  end

  show do
    attributes_table do
      row :name
      row :description
      row :status
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)

    f.inputs 'Général' do
      f.input :name,
              collection: OptionalModule.list,
              include_blank: false,
              input_html: { class: 'chosen-select' }
      f.input :description
      f.input :enabled
    end

    f.actions
  end

  #
  # == Controller
  #
  controller do
    def update
      delete_adult_cookie
      update!
    end

    private

    def delete_adult_cookie
      cookies.delete :adult if params[:optional_module][:name] == 'Adult' && params[:optional_module][:enabled] == '0'
    end
  end
end