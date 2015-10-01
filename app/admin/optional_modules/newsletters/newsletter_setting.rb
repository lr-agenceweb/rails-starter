ActiveAdmin.register NewsletterSetting do
  menu parent: I18n.t('admin_menu.config')

  permit_params :id,
                :send_welcome_email,
                :title_subscriber,
                :content_subscriber

  decorate_with NewsletterSettingDecorator
  config.clear_sidebar_sections!

  show do
    attributes_table do
      row :send_welcome_email_d
      row :title_subscriber_d
      row :content_subscriber_d
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)

    columns do
      column do
        f.inputs t('general') do
          f.input :send_welcome_email,
                  input_html: { disabled: :disabled }
        end
      end

      column do
        f.inputs t('activerecord.models.newsletter_setting.one') do
          f.translated_inputs 'Translated fields', switch_locale: false do |t|
            t.input :title_subscriber, hint: I18n.t('form.hint.title_newsletter')
            t.input :content_subscriber,
                    hint: I18n.t('form.hint.content_newsletter'),
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
    include Skippable

    before_action :redirect_to_show, only: [:index], if: proc { current_user_and_administrator? }

    private

    def redirect_to_show
      redirect_to admin_newsletter_setting_path(NewsletterSetting.first)
    end
  end
end
