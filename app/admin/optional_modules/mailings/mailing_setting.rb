# frozen_string_literal: true
ActiveAdmin.register MailingSetting do
  menu parent: I18n.t('admin_menu.modules_config')

  permit_params :id,
                :name,
                :email,
                translations_attributes: [
                  :id, :locale, :signature,
                  :unsubscribe_title, :unsubscribe_content
                ]

  decorate_with MailingSettingDecorator
  config.clear_sidebar_sections!

  show do
    arbre_cache(self, resource.cache_key) do
      columns do
        column do
          attributes_table do
            row :name_status
            row :email_status
            row :signature_d
            row :unsubscribe_title
            row :unsubscribe_content
          end
        end
      end
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)

    columns do
      column do
        f.inputs t('formtastic.titles.mailing_setting_details') do
          f.input :name
          f.input :email
        end

        f.inputs t('formtastic.titles.mailing_setting_signature') do
          f.translated_inputs 'Translated fields', switch_locale: true do |t|
            t.input :signature,
                    input_html: { class: 'froala small-height' }
          end
        end
      end

      column do
        f.inputs t('formtastic.titles.mailing_setting_unsubscribe') do
          f.translated_inputs 'Translated fields', switch_locale: true do |t|
            t.input :unsubscribe_title
            t.input :unsubscribe_content,
                    input_html: { class: 'froala' }
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
