ActiveAdmin.register SocialConnectSetting do
  menu parent: I18n.t('admin_menu.modules_config')

  permit_params :id,
                :enabled,
                social_providers_attributes: [
                  :id, :name, :enabled
                ]

  decorate_with SocialConnectSettingDecorator
  config.clear_sidebar_sections!

  show title: proc { resource.title_aa_show } do
    columns do
      column do
        attributes_table do
          row :status
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
                  hint: I18n.t('form.hint.social_connect_setting.enabled')
        end
      end
    end

    columns do
      column do
        f.inputs t('activerecord.models.social_provider.other') do
          f.has_many :social_providers, heading: false do |item|
            item.input :name,
                       as: :select,
                       hint: I18n.t('form.hint.social_provider.name')
            item.input :enabled,
                       as: :boolean,
                       hint: I18n.t('form.hint.social_provider.enabled')
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
    before_action :redirect_to_show, only: [:index], if: proc { current_user_and_administrator? && @social_connect_module.enabled? }

    private

    def redirect_to_show
      redirect_to admin_social_connect_setting_path(SocialConnectSetting.first)
    end
  end
end
