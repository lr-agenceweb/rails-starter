ActiveAdmin.register Setting, as: 'Parameter' do
  menu parent: I18n.t('admin_menu.config')

  permit_params :id,
                :name,
                :phone,
                :phone_secondary,
                :email,
                :per_page,
                :show_breadcrumb,
                :show_social,
                :show_qrcode,
                :maintenance,
                :logo,
                :logo_footer,
                :delete_logo,
                :delete_logo_footer,
                :twitter_username,
                translations_attributes: [
                  :id, :locale, :title, :subtitle
                ]

  decorate_with SettingDecorator
  config.clear_sidebar_sections!
  actions :all, except: [:new, :destroy]

  show do
    columns do
      column do
        panel t('active_admin.details', model: active_admin_config.resource_label) do
          attributes_table_for parameter.decorate do
            row :logo_deco
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
            row :phone_secondary unless resource.phone_secondary.blank?
            row :email
          end
        end
      end

      if breadcrumb_module.enabled? || social_module.enabled? || qrcode_module.enabled?
        column do
          panel t('active_admin.details', model: 'Modules') do
            attributes_table_for parameter.decorate do
              row :breadcrumb if breadcrumb_module.enabled?
              row :qrcode if qrcode_module.enabled?
              row :social if social_module.enabled?
              row :twitter_username
            end
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

    def update
      params[:setting].delete :show_social unless @social_module.enabled?
      params[:setting].delete :show_qrcode unless @qrcode_module.enabled?
      params[:setting].delete :show_breadcrumb unless @breadcrumb_module.enabled?
      super
    end

    private

    def redirect_to_show
      redirect_to admin_parameter_path(Setting.first), status: 301
    end
  end
end
