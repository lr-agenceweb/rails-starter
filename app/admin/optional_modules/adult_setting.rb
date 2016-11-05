# frozen_string_literal: true
ActiveAdmin.register AdultSetting do
  menu parent: I18n.t('admin_menu.modules_config')

  permit_params do
    params = [:id, :enabled, :redirect_link]
    params.push(*post_attributes)
    params
  end

  decorate_with AdultSettingDecorator
  config.clear_sidebar_sections!

  show do
    arbre_cache(self, resource.cache_key) do
      columns do
        column do
          attributes_table do
            row :title
            row :content
            row :redirect_link
            bool_row :enabled
          end
        end
      end
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)

    columns do
      column do
        f.inputs t('formtastic.titles.adult_setting_details') do
          f.input :enabled
          f.input :redirect_link
        end
      end
    end

    columns do
      column do
        f.inputs t('formtastic.titles.post_translations') do
          f.translated_inputs 'Translated fields', switch_locale: true do |t|
            t.input :title
            t.input :content,
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
    include ActiveAdmin::ParamsHelper
    before_action :redirect_to_show, only: [:index], if: proc { current_user_and_administrator? && @adult_module.enabled? }

    private

    def redirect_to_show
      redirect_to admin_adult_setting_path(AdultSetting.first)
    end
  end
end
