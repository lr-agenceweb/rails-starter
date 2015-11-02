ActiveAdmin.register AdultSetting do
  menu parent: I18n.t('admin_menu.modules_config')

  permit_params :id,
                :enabled,
                :redirect_link,
                translations_attributes: [
                  :id, :locale, :title, :content
                ]

  decorate_with AdultSettingDecorator
  config.clear_sidebar_sections!

  show do
    columns do
      column do
        attributes_table do
          row :status
          row :title_d
          row :content_d
          row :redirect_link
        end
      end
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)

    columns do
      column do
        f.inputs t('general') do
          f.input :enabled,
                  as: :boolean,
                  hint: I18n.t('form.hint.adult.enabled')

          f.input :redirect_link,
                  hint: raw(I18n.t('form.hint.adult.redirect_link'))
        end
      end
    end

    columns do
      column do
        f.inputs t('adult.active_admin.content') do
          f.translated_inputs 'Translated fields', switch_locale: true do |t|
            t.input :title,
                    label: I18n.t('activerecord.attributes.post.title'),
                    hint: I18n.t('form.hint.adult.title')
            t.input :content,
                    label: I18n.t('activerecord.attributes.adult_setting.content'),
                    hint: I18n.t('form.hint.adult.content'),
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
    before_action :redirect_to_show, only: [:index], if: proc { current_user_and_administrator? && @adult_module.enabled? }

    private

    def redirect_to_show
      redirect_to admin_adult_setting_path(AdultSetting.first)
    end
  end
end
