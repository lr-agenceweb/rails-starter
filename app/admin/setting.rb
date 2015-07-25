ActiveAdmin.register Setting do
  menu parent: 'configuration'

  permit_params :id,
                :name,
                :phone,
                :email,
                :show_breadcrumb,
                :show_social,
                :should_validate,
                :maintenance,
                :logo,
                :delete_logo,
                translations_attributes: [
                  :id, :locale, :title, :subtitle
                ]

  decorate_with SettingDecorator
  config.clear_sidebar_sections!
  actions :all, except: [:new, :destroy]

  index do
    column :logo
    column :name
    column :title
    column :subtitle
    column :phone
    column :email
    column :maintenance

    translation_status
    actions
  end

  show do
    columns do
      column do
        panel t('active_admin.details', model: active_admin_config.resource_label) do
          attributes_table_for setting.decorate do
            row :logo
            row :title
            row :subtitle
            row :maintenance
          end
        end
      end

      column do
        panel t('active_admin.details', model: t('role.administrator')) do
          attributes_table_for setting.decorate do
            row :name
            row :phone
            row :email
          end
        end
      end

      column do
        panel t('active_admin.details', model: 'Modules') do
          attributes_table_for setting.decorate do
            row :breadcrumb
            row :social
          end
        end
      end
    end
  end

  form do |f|
    render 'form', f: f
  end

  #
  # == Controller
  #
  controller do
    before_action :set_setting, only: [:show]
    before_action :redirect_to_show, only: [:index]

    private

    def redirect_to_show
      redirect_to admin_setting_path(@setting)
    end

    def set_setting
      @setting = Setting.find(params[:id])
      gon_params
    end
  end
end
