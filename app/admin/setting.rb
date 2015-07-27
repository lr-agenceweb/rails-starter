ActiveAdmin.register Setting, as: 'Parameter' do
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
          attributes_table_for parameter.decorate do
            row :logo
            row :title
            row :subtitle
            row :maintenance
          end
        end
      end

      column do
        panel t('active_admin.details', model: t('role.administrator')) do
          attributes_table_for parameter.decorate do
            row :name
            row :phone
            row :email
          end
        end
      end

      column do
        panel t('active_admin.details', model: 'Modules') do
          attributes_table_for parameter.decorate do
            row :breadcrumb
            row :social
          end
        end
      end
    end
  end

  form do |f|
    render '/admin/settings/form', f: f
  end

  #
  # == Controller
  #
  controller do
    before_action :redirect_to_show, only: [:index], if: proc { current_user_and_administrator? }

    private

    def redirect_to_show
      redirect_to admin_parameter_path(Setting.first)
    end
  end
end
