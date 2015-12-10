ActiveAdmin.register MailingSetting do
  menu parent: I18n.t('admin_menu.modules_config')

  permit_params :id, :email

  decorate_with MailingSettingDecorator
  config.clear_sidebar_sections!

  show do
    columns do
      column do
        attributes_table do
          row :email_status
        end
      end
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)

    columns do
      column do
        f.inputs t('general') do
          f.input :email,
                  hint: I18n.t('form.hint.mailing_setting.email')
        end
      end
    end

    f.actions
  end

  #
  # == Controller
  #
  controller do
    before_action :redirect_to_show, only: [:index], if: proc { current_user_and_administrator? && @mailing_module.enabled? }

    private

    def redirect_to_show
      redirect_to admin_mailing_setting_path(MailingSetting.first), status: 301
    end
  end
end
