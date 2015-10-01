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
      row :title_subscriber
      row :content_subscriber
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)

    columns do
      column do
        f.inputs t('general') do
          f.input :send_welcome_email,
                  hint: I18n.t('form.hint.newsletter.send_welcome_email')
        end
      end
    end

    columns id: 'newsletter_config_form' do
      column do
        f.inputs t('newsletter.active_admin.welcome_panel_title') do
          f.translated_inputs 'Translated fields', switch_locale: true do |t|
            t.input :title_subscriber,
                    label: I18n.t('activerecord.attributes.newsletter_setting.title_subscriber'),
                    hint: I18n.t('form.hint.newsletter.title_subscriber')
            t.input :content_subscriber,
                    label: I18n.t('activerecord.attributes.newsletter_setting.content_subscriber'),
                    hint: I18n.t('form.hint.newsletter.content_subscriber'),
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
