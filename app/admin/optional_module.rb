ActiveAdmin.register OptionalModule do
  menu parent: I18n.t('admin_menu.config')

  permit_params :id,
                :name,
                :description,
                :enabled

  decorate_with OptionalModuleDecorator
  config.clear_sidebar_sections!

  batch_action :toggle_enabled do |ids|
    OptionalModule.find(ids).each { |item| item.toggle! :enabled }
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
              include_blank: false
      f.input :description
      f.input :enabled
    end

    f.actions
  end

  #
  # == Controller
  #
  controller do
    include Skippable

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
