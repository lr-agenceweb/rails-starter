ActiveAdmin.register MailingSetting do
  menu parent: I18n.t('admin_menu.modules_config')

  permit_params :id,
                :name,
                :email,
                translations_attributes: [
                  :id, :locale, :signature
                ]

  decorate_with MailingSettingDecorator
  config.clear_sidebar_sections!

  show do
    columns do
      column do
        attributes_table do
          row :name_status
          row :email_status
          row :signature_d
        end
      end
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)

    columns do
      column do
        f.inputs t('general') do
          f.input :name,
                  hint: I18n.t('form.hint.mailing_setting.name')
          f.input :email,
                  hint: I18n.t('form.hint.mailing_setting.email')
        end
      end

      column do
        f.inputs 'Signature' do
          f.translated_inputs 'Translated fields', switch_locale: true do |t|
            t.input :signature,
                    hint: I18n.t('form.hint.mailing_setting.signature'),
                    input_html: { class: 'froala small-height' }
          end
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
