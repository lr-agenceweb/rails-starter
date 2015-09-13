ActiveAdmin.register OptionalModule do
  menu parent: I18n.t('admin_menu.config')

  permit_params :id,
                :name,
                :description,
                :enabled

  decorate_with OptionalModuleDecorator
  config.clear_sidebar_sections!

  batch_action :toggle_value do |ids|
    OptionalModule.find(ids).each do |optional_module|
      toggle_value = optional_module.enabled? ? false : true
      optional_module.update_attribute(:enabled, toggle_value)
    end
    redirect_to :back, notice: t('active_admin.batch_actions.flash')
  end

  index do
    selectable_column
    column :name_deco
    column :status
    column :description

    actions
  end

  show title: :title_aa_show do
    attributes_table do
      row :name_deco
      row :status
      row :description
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
      super
    end

    private

    def delete_adult_cookie
      cookies.delete :adult if params[:optional_module][:name] == 'Adult' && params[:optional_module][:enabled] == '0'
    end
  end
end
